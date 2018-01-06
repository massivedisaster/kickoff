package com.massivedisaster.kickoff.config;

/**
 * Created by nunosilva on 30/05/17.
 */
public class QualityVerifier {

    private String version;
    private Option checkstyle;
    private Option findbugs;
    private Option pmd;
    private Option lint;
    private Option cpd;

    public String getVersion() {
        return version;
    }

    public Option getCheckstyle() {
        return checkstyle;
    }

    public Option getFindbugs() {
        return findbugs;
    }

    public Option getPmd() {
        return pmd;
    }

    public Option getLint() {
        return lint;
    }

    public Option getCpd() {
        return cpd;
    }

    public class Option {
        private boolean skip;

        public boolean isSkip() {
            return skip;
        }
    }
}
