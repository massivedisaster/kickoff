package com.massivedisaster.kickoff;

import com.massivedisaster.kickoff.config.Dependencies;
import com.massivedisaster.kickoff.config.ProjectConfiguration;
import com.massivedisaster.kickoff.network.KickoffService;
import com.massivedisaster.kickoff.util.Cli;
import com.massivedisaster.kickoff.util.Const;
import com.massivedisaster.kickoff.util.FileUtils;
import com.massivedisaster.kickoff.util.TextUtils;
import freemarker.cache.*;
import freemarker.template.*;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;

import java.io.*;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**
 * Generate a new android project based on configurations
 */
public class Kickoff {

    /**
     * @param args the command line arguments.
     */
    public static void main(String[] args) {

        System.out.println("kickoff v.0.0.2 - A tool to generate new android projects based on a powerful template.\n");

        Cli cli = new Cli(args);
        cli.parse();

        if (cli.getOptions().hasOption("g")) {
            try {
                generateNewProject(cli.getOptions().getOptionValue("g"));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Generate a new project based on a configuration file
     */
    private static void generateNewProject(String fileName) throws Exception {
        FileReader configurationFile = new FileReader(fileName);

        ProjectConfiguration project = FileUtils.validateConfigurationFile(configurationFile);

        String template = project.getTemplate();
        if (TextUtils.isEmpty(template)) {
            System.out.println("Invalid template");
            return;
        }

        System.out.println("Generating new project...");

        if (TextUtils.isValidURL(template)) {
            downloadTemplate(project);
        } else {
            accessLocalFile(project);
        }
    }

    /**
     * Access local File from a path
     *
     * @param project The project configurations.
     */
    private static void accessLocalFile(final ProjectConfiguration project) {
        File f = new File(project.getTemplate());

        if (!f.exists()) {
            System.out.println("File not exists");
            return;
        }

        System.out.println("Access File with success");

        String folderName = TextUtils.normalizeString(project.getProjectName());

        if (FileUtils.extractFile(f.getAbsolutePath(), folderName, false)) {
            try {
                applyConfigurations(folderName, project);
            } catch (IOException e) {
                e.printStackTrace();
            } catch (TemplateException e) {
                e.printStackTrace();
            }
        }

        System.out.println("Project " + project.getProjectName() + " created.");
    }

    /**
     * Download the last template form GitHub.
     *
     * @param project The project configurations.
     */
    private static void downloadTemplate(final ProjectConfiguration project) {
        System.out.println("Downloading the template...");
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(Const.LIBRARY_REPOSITORY_URL)
                .build();

        KickoffService service = retrofit.create(KickoffService.class);
        Call<ResponseBody> call = service.downloadTemplate(project.getTemplate());
        call.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                if (response.isSuccessful() && response.body() != null) {
                    System.out.println("Download success.");

                    String folderName = TextUtils.normalizeString(project.getProjectName());

                    if (FileUtils.writeTemplateToDisk(response.body().byteStream(), folderName)) {
                        try {
                            applyConfigurations(folderName, project);
                        } catch (IOException e) {
                            e.printStackTrace();
                        } catch (TemplateException e) {
                            e.printStackTrace();
                        }
                    }

                    System.out.println("Project " + project.getProjectName() + " created.");
                } else {
                    System.out.println("Error getting template from the server.");
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                t.printStackTrace();
            }
        });
    }

    /**
     * Iterate all the FTL's in the folder and apply configurations
     *
     * @param folderName           The project folder to iterate and apply configurations.
     * @param projectConfiguration The configuration to apply.
     * @throws IOException
     * @throws TemplateException
     */
    private static void applyConfigurations(String folderName, ProjectConfiguration projectConfiguration) throws IOException, TemplateException {
        System.out.println("Applying project configurations...");

        File projectDirectory = new File(folderName);
        FileUtils.changePackageDirectoryName(projectDirectory, projectConfiguration.getPackageName().replace(".", "/"));

        Map<String, Object> input = new HashMap<>();
        input.put("configs", projectConfiguration);

        Configuration cfg = new Configuration();
        cfg.setDirectoryForTemplateLoading(new File("").getAbsoluteFile());
        cfg.setIncompatibleImprovements(new Version(2, 3, 20));
        cfg.setDefaultEncoding("UTF-8");
        cfg.setLocale(Locale.US);
        cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);

        for (File file : FileUtils.findAllFilesBasedOnAExtention(projectDirectory, ".ftl")) {
            if (fileIsNeeded(projectConfiguration.getDependencies(), file)) {
                Template template = cfg.getTemplate(file.getPath());

                Writer fileWriter = new FileWriter(FileUtils.newFileStripExtension(file.getAbsolutePath()));
                try {
                    template.process(input, fileWriter);
                } finally {
                    fileWriter.close();

                    if (!file.delete()) {
                        System.out.println("Delete operation is failed.");
                    }
                }
            } else {
                file.delete();
            }
        }
    }

    private static boolean fileIsNeeded(Dependencies dependencies, File file) {
        if (dependencies == null || (dependencies.getRetrofit() == null && file.getName().contains("RetrofitAdapter"))) {
            return false;
        }
        return true;
    }
}
