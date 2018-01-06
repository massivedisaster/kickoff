Kickoff
===============
A tool to generate new android projects based on a powerful template.

About
-----
With this tool you just have to create a project configuration file like the one below and run it. 
It will create a new android project based on configurations.

## Installation

Just build and create configuration file.

## Project configuration file

The configuration file must be named `what_you_want.json`.
```js
// The json configuration
{
  "language" : "java",                                          // Mandatory
  "gradlePluginVersion" : "2.3.0",                              // Mandatory
  "projectType" : "mobile",                                     // Mandatory
  "projectName" : "Kickoff Sample",                             // Mandatory
  "packageName" : "com.massivedisaster.kickoff.example",        // Mandatory
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

## Usage

- Running the JAR:
```
  $ java -jar kickoff.jar -g project_configuration.json
```

- Also you can use the [scripts](https://github.com/massivedisaster/kickoff/tree/master/scripts) available for Linux, OSX & Windows:
```
  $ kickoff -g project_configuration.json
```

## License
[GNU LESSER GENERAL PUBLIC LICENSE](LICENSE.md)
