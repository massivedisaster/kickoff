<#if configs.qualityVerifier??>
check {
  <#if configs.qualityVerifier.checkstyle??>

  checkstyle {
    skip ${configs.qualityVerifier.checkstyle.skip?c}
  }
  </#if>
  <#if configs.qualityVerifier.findbugs??>

  findbugs {
    skip ${configs.qualityVerifier.findbugs.skip?c}
  }
  </#if>
  <#if configs.qualityVerifier.pmd??>

  pmd {
    skip ${configs.qualityVerifier.pmd.skip?c}
  }
  </#if>
  <#if configs.qualityVerifier.lint??>

  lint {
    skip ${configs.qualityVerifier.lint.skip?c}
  }
  </#if>
  <#if configs.qualityVerifier.cpd??>

  cpd {
    skip ${configs.qualityVerifier.cpd.skip?c}
  }
  </#if>

}
</#if>
