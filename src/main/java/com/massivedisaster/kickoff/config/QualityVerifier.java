package com.massivedisaster.kickoff.config;

/**
 * Created by nunosilva on 30/05/17.
 */
public class QualityVerifier {

    private boolean checkstyle;
    private boolean findbugs;
    private boolean pmd;
    private boolean lint;

    public boolean isCheckstyle() {
        return checkstyle;
    }

    public boolean isFindbugs() {
        return findbugs;
    }

    public boolean isPmd() {
        return pmd;
    }

    public boolean isLint() {
        return lint;
    }
}
