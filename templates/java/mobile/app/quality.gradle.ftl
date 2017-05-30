check {
  <#if configs.qualityVerifier??>
  checkstyle {
    skip ${configs.qualityVerifier.checkstyle?string}
  }

  findbugs {
    skip ${configs.qualityVerifier.findbugs?string}
  }

  pmd {
    skip ${configs.qualityVerifier.pmd?string}
  }

  lint {
    skip ${configs.qualityVerifier.lint?string}
  }
  </#if>
}
