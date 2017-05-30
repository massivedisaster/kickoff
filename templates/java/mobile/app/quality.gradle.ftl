check {

  <#if configs.qualityVerifier??>
         checkstyle {
           skip ${configs.qualityVerifier.checkstyle}
         }

         findbugs {
           skip ${configs.qualityVerifier.findbugs}
         }

         pmd {
           skip ${configs.qualityVerifier.pmd}
         }

         lint {
           skip ${configs.qualityVerifier.lint}
         }
  <#if>
}
