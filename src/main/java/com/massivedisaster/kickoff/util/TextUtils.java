package com.massivedisaster.kickoff.util;

import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.text.Normalizer;

/**
 * Created by nunosilva on 01/06/17.
 */
public class TextUtils {

    /**
     * Normalize a string and remove white spaces
     *
     * @param string the string to normalize.
     * @return the normalized string.
     */
    public static String normalizeString(String string) {
        String stringNormalized = Normalizer.normalize(string, Normalizer.Form.NFD);
        stringNormalized = stringNormalized.replaceAll("[^\\p{ASCII}]", "");
        return stringNormalized.replaceAll("\\s+", "");
    }

    /**
     * Check if a string is null or empty
     *
     * @param string
     * @return
     */
    public static boolean isEmpty(String string) {
        return string == null || string.isEmpty() || string.trim().isEmpty();
    }

    /**
     * Check if a url is valid or not
     *
     * @param url
     * @return
     */
    public static boolean isValidURL(String url) {
        URL u;
        try {
            u = new URL(url);
        } catch (MalformedURLException e) {
            return false;
        }
        try {
            u.toURI();
        } catch (URISyntaxException e) {
            return false;
        }
        return true;
    }
}
