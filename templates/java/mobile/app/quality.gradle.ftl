check {
  <#if configs.qualityVerifier??>
  checkstyle {
    skip ${configs.qualityVerifier.checkstyle?c}
  }

  findbugs {
    skip ${configs.qualityVerifier.findbugs?c}
  }

  pmd {
    skip ${configs.qualityVerifier.pmd?c}
  }

  lint {
    skip ${configs.qualityVerifier.lint?c}
  }
  </#if>
}
