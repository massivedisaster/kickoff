package com.massivedisaster.kickoff;

import java.io.*;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.zip.GZIPInputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import com.google.gson.Gson;

import com.massivedisaster.kickoff.config.ProjectConfiguration;
import com.massivedisaster.kickoff.network.KickoffService;
import com.massivedisaster.kickoff.util.Cli;
import com.massivedisaster.kickoff.util.Const;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import freemarker.template.Version;
import okhttp3.ResponseBody;
import org.rauschig.jarchivelib.Archiver;
import org.rauschig.jarchivelib.ArchiverFactory;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;

/**
 * Generate a new android project based on configurations
 */
public class Kickoff {

	/**
	 * @param args the command line arguments.
	 */
	public static void main(String[] args) {

        System.out.println("kickoff v.0.0.1 - A tool to generate new android projects based on a powerful template.\n");

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
     * Download the last template form GitHub.
     * @param project The project configurations.
     */
    private static void downloadTemplate(final ProjectConfiguration project){
        System.out.println("Downloading the template...");
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(Const.WEBSITE_URL)
                .build();

        KickoffService service = retrofit.create(KickoffService.class);
        Call<ResponseBody> call = service.downloadTemplate(project.getLanguage(), project.getProjectType());
        call.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                if (response.isSuccessful()) {
                    System.out.println("Download success.");

                    String folderName = normalizeString(project.getProjectName());

                    if(writeTemplateToDisk(response.body(), folderName)){
                        File projectDirectory = new File(folderName);
                        changePackageDirectoryName(projectDirectory, project.getPackageName().replace(".", "/"));

                        try {
                            applyConfigurations(projectDirectory, project);
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
     * Write template in disk.
     * @param body The response body to unpack and save in disk.
     * @return True if has successful saved.
     */
    private static boolean writeTemplateToDisk(ResponseBody body, String dirName) {

        FileOutputStream fout = null;
        try {
            fout = new FileOutputStream("template.tar.gz");

            final byte data[] = new byte[1024];
            int count;
            while ((count = body.byteStream().read(data, 0, 1024)) != -1) {
                fout.write(data, 0, count);
            }

            System.out.println("Temporary file created!");
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }finally {
            try {
                if(fout!= null){
                    fout.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        File file = new File(dirName);
        if(!file.exists() && file.mkdir()){
            System.out.println("Directory " + dirName + " created!");
            Archiver archiver = ArchiverFactory.createArchiver("tar", "gz");
            try {
                File template = new File("template.tar.gz");
                archiver.extract(template, file);
                System.out.println("Template extracted with success!");

                if(template.delete()){
                    System.out.println("Temporary file deleted!");
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

            return true;
        }

        System.out.println("Error: " + dirName + " already exists!");

        return false;
    }



    /**
	 * Generate a new project based on a configuration file
	 */
	private static void generateNewProject(String fileName) throws Exception{
		FileReader configurationFile = new FileReader(fileName);		
		
		ProjectConfiguration project = validateConfigurationFile(configurationFile);
		
		File folderProject = new File(project.getProjectName());
		
		String defaultProject = getExecutionPath();

		System.out.println("Generating new project...");

        downloadTemplate(project);
	}
	
	private static String getExecutionPath(){
	    String absolutePath = Kickoff.class.getProtectionDomain().getCodeSource().getLocation().getPath();
	    absolutePath = absolutePath.substring(0, absolutePath.lastIndexOf("/"));
	    absolutePath = absolutePath.replaceAll("%20"," "); // Surely need to do this here
	    return absolutePath;
	}
	
	/**
	 * Verify if the file configuration is in a valid format
	 * @param fileReader the file reader to validate.
	 * @return true if the file it's valid.
	 */
	private static ProjectConfiguration validateConfigurationFile(FileReader fileReader){
		Gson gson = new Gson();
		return gson.fromJson(fileReader, ProjectConfiguration.class);
	}
	 
	 /**
	  * Iterate all the FTL's in the folder and apply configurations
	  * 
	  * @param folderProject The project folder to iterate and apply configurations.
	  * @param projectConfiguration The configuration to apply.
	 * @throws IOException 
	 * @throws TemplateException 
	  */
	 private static void applyConfigurations(File folderProject, ProjectConfiguration projectConfiguration) throws IOException, TemplateException{
         System.out.println("Applying project configurations...");

         Map<String, Object> input = new HashMap<String, Object>();
		input.put("configs", projectConfiguration);
		  
		Configuration cfg = new Configuration();
		cfg.setDirectoryForTemplateLoading(new File("").getAbsoluteFile());
		cfg.setIncompatibleImprovements(new Version(2, 3, 20));
		cfg.setDefaultEncoding("UTF-8");
		cfg.setLocale(Locale.US);
		cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
		
		for(File file : findAllFilesBasedOnAExtention(folderProject, ".ftl")){
		    Template template = cfg.getTemplate(file.getPath());
		
		    Writer fileWriter = new FileWriter(new File(stripExtension(file.getAbsolutePath())));
		    try {
		        template.process(input, fileWriter);
		    } finally {
		        fileWriter.close();
		        
		        if(!file.delete()){
	    			System.out.println("Delete operation is failed.");
	    		}
		    }
        } 
	 }
	 
	 /**
	  * Find all files in a directory with a specify extension
	  * @param folder The directory to apply find.
	  * @param extension The extension to find.
	  * @return The list of files with the specific extension.
	  */
	 private static List<File> findAllFilesBasedOnAExtention(File folder, String extension){
		 	List<File> lstFiles = new ArrayList<File>();
		 
	        File[] fList = folder.listFiles();
	        for (File file : fList) {
	            if (file.isFile() && file.getName().endsWith(extension)) {
	            	lstFiles.add(file);
	            } else if (file.isDirectory()) {
	            	lstFiles.addAll(findAllFilesBasedOnAExtention(file, extension));
	            }
	        }
	        
	        return lstFiles;
	 }
	 
	 /**
	  * Strip the last extension of a file name
	  * @param fileName The original filename.
	  * @return the fileName without the last extension
	  */
	 private static String stripExtension(final String fileName){
	     return fileName != null &&fileName.lastIndexOf(".") > 0 ? fileName.substring(0, fileName.lastIndexOf(".")) : fileName;
	 }

	 private static void changePackageDirectoryName(File projectFolder, final String packageName){
	        File[] fList = projectFolder.listFiles();
	        for (File file : fList) {
	        	if(file.isDirectory() && file.getName().equals("app_package")){
	        		File packageFolder = new File(file.getParentFile().getPath() + "/" + packageName);
        		    if (!packageFolder.exists()) {
        		    	packageFolder.mkdirs();
        		    }
	        		
	        		file.renameTo(packageFolder);
	        	}else if (file.isDirectory()) {
	        		changePackageDirectoryName(file, packageName);
	            }
	        } 
	 }

    /**
     * Normalize a string and remove white spaces
     * @param string the string to normalize.
     * @return the normalized string.
     */
    public static String normalizeString(String string) {
        String stringNormalized = Normalizer.normalize(string, Normalizer.Form.NFD);
        stringNormalized = stringNormalized.replaceAll("[^\\p{ASCII}]", "");
        return stringNormalized.replaceAll("\\s+", "");
    }
}
