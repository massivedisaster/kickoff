package com.massivedisaster.kickoff.util;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.massivedisaster.kickoff.config.ProjectConfiguration;
import org.rauschig.jarchivelib.Archiver;
import org.rauschig.jarchivelib.ArchiverFactory;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by nunosilva on 01/06/17.
 */
public class FileUtils {


    /**
     * Verify if the file configuration is in a valid format
     *
     * @param fileReader the file reader to validate.
     * @return true if the file it's valid.
     */
    public static ProjectConfiguration validateConfigurationFile(FileReader fileReader) throws IOException {
        JsonFactory jsonFactory = new JsonFactory();
        jsonFactory.enable(JsonParser.Feature.ALLOW_COMMENTS);
        ObjectMapper mapper = new ObjectMapper(jsonFactory);
        return mapper.readValue(fileReader, ProjectConfiguration.class);
    }

    /**
     * Extract all files from pathFile to the dirName folder
     *
     * @param pathFile
     * @param dirName
     * @param deleteAfter
     * @return
     */
    public static boolean extractFile(String pathFile, String dirName, boolean deleteAfter) {
        File file = new File(dirName);
        if (!file.exists() && file.mkdir()) {
            System.out.println("Directory " + dirName + " created!");
            Archiver archiver = ArchiverFactory.createArchiver("tar", "gz");
            try {
                File template = new File(pathFile);
                archiver.extract(template, file);
                System.out.println("Template extracted with success!");

                if (deleteAfter && template.delete()) {
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
     * Write template in disk.
     *
     * @param inputStream The response body to unpack and save in disk.
     * @return True if has successful saved.
     */
    public static boolean writeTemplateToDisk(InputStream inputStream, String dirName) {
        if (inputStream == null || TextUtils.isEmpty(dirName)) {
            System.out.println("InputStream or dirname is null");
            return false;
        }

        FileOutputStream fout = null;
        try {
            fout = new FileOutputStream("template.tar.gz");

            final byte data[] = new byte[1024];
            int count;
            while ((count = inputStream.read(data, 0, 1024)) != -1) {
                fout.write(data, 0, count);
            }

            System.out.println("Temporary file created!");
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (fout != null) {
                    fout.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return extractFile("template.tar.gz", dirName, true);
    }

    /**
     * Find all files in a directory with a specify extension
     *
     * @param folder    The directory to apply find.
     * @param extension The extension to find.
     * @return The list of files with the specific extension.
     */
    public static List<File> findAllFilesBasedOnAExtention(File folder, String extension) {
        List<File> lstFiles = new ArrayList<File>();

        File[] fList = folder.listFiles();
        if(fList!=null){
            for (File file : fList) {
                if (file.isFile() && file.getName().endsWith(extension)) {
                    lstFiles.add(file);
                } else if (file.isDirectory()) {
                    lstFiles.addAll(findAllFilesBasedOnAExtention(file, extension));
                }
            }
        }

        return lstFiles;
    }

    /**
     * Create all folders
     *
     * @param projectFolder
     * @param packageName
     */
    public static void changePackageDirectoryName(File projectFolder, final String packageName) {
        File[] fList = projectFolder.listFiles();
        for (File file : fList) {
            if (file.isDirectory() && file.getName().equals("app_package")) {
                File packageFolder = new File(file.getParentFile().getPath() + "/" + packageName);
                if (!packageFolder.exists()) {
                    packageFolder.mkdirs();
                }

                file.renameTo(packageFolder);
            } else if (file.isDirectory()) {
                changePackageDirectoryName(file, packageName);
            }
        }
    }

    /**
     * Create a new file and strip the last extension of a file name
     *
     * @param fileName The original filename.
     * @return the file without the last extension
     */
    public static File newFileStripExtension(final String fileName) {
        return new File(stripExtension(fileName));
    }

    /**
     * Strip the last extension of a file name
     *
     * @param fileName The original filename.
     * @return the fileName without the last extension
     */
    private static String stripExtension(final String fileName) {
        return fileName != null && fileName.lastIndexOf(".") > 0 ? fileName.substring(0, fileName.lastIndexOf(".")) : fileName;
    }
}
