package com.massivedisaster.kickoff

import com.massivedisaster.kickoff.config.ProjectConfiguration
import com.massivedisaster.kickoff.network.KickoffService
import com.massivedisaster.kickoff.util.Cli
import com.massivedisaster.kickoff.util.Const
import com.massivedisaster.kickoff.util.FileUtils
import com.massivedisaster.kickoff.util.TextUtils
import freemarker.template.Configuration
import freemarker.template.TemplateException
import freemarker.template.TemplateExceptionHandler
import freemarker.template.Version
import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import java.io.*
import java.util.*

/**
 * Generate a new android project based on configurations
 */
    /**
     * @param args the command line arguments.
     */
    fun main(args: Array<String>) {
        println("kickoff v.0.0.4 - A tool to generate new android projects based on a powerful template.\n")
        val cli = Cli(args)
        cli.parse()
        if (cli.options.hasOption("g")) {
            try {
                generateNewProject(cli.options.getOptionValue("g"))
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    /**
     * Generate a new project based on a configuration file
     */
    private fun generateNewProject(fileName: String) {
        val configurationFile = FileReader(fileName)
        val project = FileUtils.validateConfigurationFile(configurationFile)
        val template = project.template
        if (TextUtils.isEmpty(template)) {
            println("Invalid template")
            return
        }
        println("Generating new project...")
        if (TextUtils.isValidURL(template)) {
            downloadTemplate(project)
        } else {
            accessLocalFile(project)
        }
    }

    /**
     * Access local File from a path
     *
     * @param project The project configurations.
     */
    private fun accessLocalFile(project: ProjectConfiguration) {
        val f = File(project.template)
        if (!f.exists()) {
            println("File not exists")
            return
        }
        println("Access File with success")
        val folderName = TextUtils.normalizeString(project.projectName)
        if (FileUtils.extractFile(f.absolutePath, folderName, false)) {
            try {
                applyConfigurations(folderName, project)
            } catch (e: IOException) {
                e.printStackTrace()
            } catch (e: TemplateException) {
                e.printStackTrace()
            }
        }
        println("Project " + project.projectName + " created.")
    }

    /**
     * Download the last template form GitHub.
     *
     * @param project The project configurations.
     */
    private fun downloadTemplate(project: ProjectConfiguration) {
        println("Downloading the template...")
        val retrofit = Retrofit.Builder()
                .baseUrl(Const.LIBRARY_REPOSITORY_URL)
                .build()
        val service = retrofit.create(KickoffService::class.java)
        val call = service.downloadTemplate(project.template)
        call.enqueue(object : Callback<ResponseBody?> {
            override fun onResponse(call: Call<ResponseBody?>, response: Response<ResponseBody?>) {
                if (response.isSuccessful && response.body() != null) {
                    println("Download success.")
                    val folderName = TextUtils.normalizeString(project.projectName)
                    if (FileUtils.writeTemplateToDisk(response.body()!!.byteStream(), folderName)) {
                        try {
                            applyConfigurations(folderName, project)
                        } catch (e: IOException) {
                            e.printStackTrace()
                        } catch (e: TemplateException) {
                            e.printStackTrace()
                        }
                    }
                    println("Project " + project.projectName + " created.")
                } else {
                    println("Error getting template from the server.")
                }
                System.exit(0)
            }

            override fun onFailure(call: Call<ResponseBody?>, t: Throwable) {
                t.printStackTrace()
            }
        })
    }

    /**
     * Iterate all the FTL's in the folder and apply configurations
     *
     * @param folderName           The project folder to iterate and apply configurations.
     * @param projectConfiguration The configuration to apply.
     * @throws IOException
     * @throws TemplateException
     */
    @Throws(IOException::class, TemplateException::class)
    private fun applyConfigurations(folderName: String, projectConfiguration: ProjectConfiguration) {
        println("Applying project configurations...")
        val projectDirectory = File(folderName)
        FileUtils.changePackageDirectoryName(projectDirectory, projectConfiguration.packageName.replace(".", "/"))
        val input: MutableMap<String, Any> = HashMap()
        input["configs"] = projectConfiguration
        val cfg = Configuration(Version(2, 3, 20))
        cfg.setDirectoryForTemplateLoading(File("").absoluteFile)
        cfg.defaultEncoding = "UTF-8"
        cfg.locale = Locale.US
        cfg.templateExceptionHandler = TemplateExceptionHandler.RETHROW_HANDLER
        for (file in FileUtils.findAllFilesBasedOnAExtention(projectDirectory, ".ftl")) {
            val template = cfg.getTemplate(file.path)
            val fileWriter: Writer = FileWriter(FileUtils.newFileStripExtension(file.absolutePath))
            try {
                template.process(input, fileWriter)
            } finally {
                fileWriter.close()
                if (!file.delete()) {
                    println("Delete operation is failed.")
                }
            }
        }
    }