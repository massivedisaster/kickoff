package com.massivedisaster.kickoff;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.google.gson.Gson;

import com.massivedisaster.kickoff.config.ProjectConfiguration;
import com.massivedisaster.kickoff.util.Cli;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import freemarker.template.Version;

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
	 * Generate a new project based on a configuration file
	 */
	private static void generateNewProject(String fileName) throws Exception{
		FileReader configurationFile = new FileReader(fileName);		
		
		ProjectConfiguration project = validateConfigurationFile(configurationFile);
		
		File folderProject = new File(project.getProjectName());
		
		String defaultProject = getExecutionPath();

		System.out.println("Generating new project...");

		copyDirectory(new File( defaultProject +"/templates/" + project.getProjectType()), folderProject);
		
		changePackageDirectoryName(folderProject, project.getPackageName().replace(".", "/"));

		applyConfigurations(folderProject, project);

		System.out.println("Project " + project.getProjectName() + " created.");
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
	 * Copy default project directory
	 */
	 private static void copyDirectory(File sourceLocation , File targetLocation)
			    throws IOException {
		 
        if (sourceLocation.isDirectory()) {
            if (!targetLocation.exists()) {
                targetLocation.mkdir();
            }

            String[] children = sourceLocation.list();
            for (int i=0; i<children.length; i++) {
                copyDirectory(new File(sourceLocation, children[i]),
                        new File(targetLocation, children[i]));
            }
        } else {
            InputStream in = new FileInputStream(sourceLocation);
            OutputStream out = new FileOutputStream(targetLocation);

            byte[] buf = new byte[1024];
            int len;
            while ((len = in.read(buf)) > 0) {
                out.write(buf, 0, len);
            }
            in.close();
            out.close();
        }
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
}
