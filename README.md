Kickoff
===============
A tool to generate new android projects based on a powerful template.

Usage
-----
With this tool you just have to create a configuration file like the one below, build the jar and run it. 
It will create a new android project based on configurations.

Configuration
-------------
### Install

Just build and create configuration file.

### Project configuration file (project_configuration.json)
The configuration file must be named `what_you_want.json`.
```js
// The json configuration
{
  "language" : "java",                                          // Mandatory
  "gradlePluginVersion" : "2.3.0",                              // Mandatory
  "projectType" : "mobile",                                     // Mandatory
  "projectName" : "Kickoff Sample",                             // Mandatory
  "packageName" : "com.massivedisaster.kickoff.exampe",         // Mandatory
  "minimumSdkApi" : 16,                                         // Mandatory
  "targetSdkApi" : 25,                                          // Mandatory
  "buildTools" : "25.0.3",                                      // Mandatory
  "retrofit" : {
    "timeout" : 30,
    "prod" : "http://massivedisaster.com/api/prod",
    "dev" : "http://massivedisaster.com/api/dev"
  }
}

```

### License
[GNU LESSER GENERAL PUBLIC LICENSE](LICENSE.md)
