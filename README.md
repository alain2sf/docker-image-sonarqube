# SonarQube with Docker

[TOC "float:right"]

## 1. Build/Run a SonarQube Server Docker Image

### 1.1. Create the Docker Initial Image

1. Change/Customize your image name/tag into `_build.sh`
> Refers Dockerfile: `Dockerfile.sonarqube`

2. Run the shell file `_build.sh` to build the initial docker image

### 1.2. Create/Run the Container

1. Change/Customize your image name/tag, hosts, ports and container name into `_run.sh`
> Refers init command: `run.sh`

2. Run `_run.sh` to create and start the container from image created at step 1
> Then use `docker stop|start container_name` commands to stop/start the container <br>
> Check your container with `docker ps [-a]` <br>
> Remove your container with `docker rm container_name`


### 1.3. BASH Shell Session to the Container

1. Change/Customize your container name into `_exec.sh`

2. Run `_exec.sh` to create a bash shell session to the container


### 1.4. Notes

- Original Official Dockerfile for SonarQube: https://registry.hub.docker.com/_/sonarqube/

- How to install and configure SonarQube Runner (Analyser): http://docs.sonarqube.org/display/SONAR/Installing+and+Configuring+SonarQube+Runner

- How to analyse your source code: http://docs.sonarqube.org/display/SONAR/Analyzing+with+SonarQube+Runner

### 1.5. Important Before Continuing Further

- Prepare the /etc/hosts of the Docker Host: `192.168.99.100  sonarqube.zenentropy.net`

	```bash
	$ docker-machine ls
	NAME   ACTIVE   DRIVER       STATE     URL                         SWARM
	dev    *        virtualbox   Running   tcp://192.168.99.100:2376
	```

- Once the container is started test SonarQube Web front end from host browser: http://sonarqube.zenentropy.net:9000
	> No need to be logged in to browse an analysed project (public access)

- Double check and eventually install/update the right language plugin (Java plugin is installed by default but might need an update): http://docs.sonarqube.org/display/PLUG/Java+Plugin
	> 1. Login as administrator 
	> __Administrator user credentials:__ admin/admin <br>
	> 2. Go to: Settings | System | Update Center <br>
	> 3. Use: "Installed Plugins" or "Available Plugins" or "Plugin Updates" depending on your source code language requirement <br>
	> 4. A restart of SonarQube will generally be needed after an install/update
	> 5. Exit any Docker exec session and restart the container

<br>
<br>
## 2. Setup Sonar Runner to Analyse Java Source Code

### 2.1. Analysing the source code

- ##### Start a Docker exec session with a bash shell

	```bash
	$ _exec.sh

	root@sonarqube:/opt/sonarqube# cd
	root@sonarqube:~# sonar-runner -h
	INFO:
	INFO: usage: sonar-runner [options]
	INFO:
	INFO: Options:
	INFO:  -D,--define <arg>     Define property
	INFO:  -e,--errors           Produce execution error messages
	INFO:  -h,--help             Display help information
	INFO:  -v,--version          Display version information
	INFO:  -X,--debug            Produce execution debug output
	```

- ##### Get the source code and expand it under the defined project directory

    ```bash
    root@sonarqube:~/MySampleSources# curl -O http://<source>/MySampleSources-Tree.tgz
    root@sonarqube:~/MySampleSources# tar xvzf MySampleSources-Tree.tgz
    root@sonarqube:~/MySampleSources# rm MySampleSources-Tree.tgz
    root@sonarqube:~/MySampleSources# cd ..
    ```

- ##### Launch Sonar Runner
Sonar Runner command must be executed at the same level as the corresponding project properties file `sonar-project.properties`, otherwise use the -D swich, or change the sonar.sources property accordingly
>     sonar-runner -Dsonar.sources=./MySampleSources \
>     -Dsonar.projectKey=MySampleSources \
>     -Dsonar.projectName=MySampleSources \
>     -Dsonar.projectVersion=1.0
> NOTE: The `sonar-project.properties` file defines the project (source code tree) to be analysed, the source directory location is relative to the properties file as the sonar.sources property is meant to define it (./MySampleSources)

<br>
```bash
root@sonarqube:~/# sonar-runner
SonarQube Runner 2.4
Java 1.8.0_45-internal Oracle Corporation (64-bit)
Linux 4.0.5-boot2docker amd64
INFO: Runner configuration file: /root/sonar-runner-2.4/conf/sonar-runner.properties
INFO: Project configuration file: /root/sonar-project.properties
INFO: Default locale: "en", source code encoding: "UTF-8" (analysis is platform dependent)
INFO: Work directory: /root/./.sonar
INFO: SonarQube Server 5.1.1
15:10:25.918 INFO  - Load global repositories
15:10:26.048 INFO  - Load global repositories (done) | time=131ms
15:10:26.049 INFO  - Server id: 20150624133445
15:10:26.051 INFO  - User cache: /root/.sonar/cache
15:10:26.068 INFO  - Install plugins
15:10:26.073 INFO  - Download sonar-email-notifications-plugin-5.1.1.jar
15:10:26.109 INFO  - Download sonar-core-plugin-5.1.1.jar
15:10:26.114 INFO  - Download sonar-java-plugin-3.3.jar
15:10:26.167 INFO  - Download sonar-scm-git-plugin-1.1.jar
15:10:26.210 INFO  - Download sonar-l10n-en-plugin-5.1.1.jar
15:10:26.214 INFO  - Download sonar-scm-svn-plugin-1.1.jar
15:10:26.343 INFO  - Install JDBC driver
15:10:26.346 INFO  - Download h2-1.3.176.jar
15:10:26.365 INFO  - Create JDBC datasource for jdbc:h2:tcp://localhost:9092/sonar
15:10:27.462 INFO  - Initializing Hibernate
15:10:28.428 INFO  - Load project repositories
15:10:28.773 INFO  - Load project repositories (done) | time=345ms
15:10:28.774 INFO  - Load project settings
15:10:28.998 INFO  - Load technical debt model
15:10:29.016 INFO  - Apply project exclusions
15:10:29.716 WARN  - SCM provider autodetection failed. No SCM provider claims to support this project. Please use sonar.scm.provider to define SCM of your project.
15:10:29.718 INFO  - -------------  Scan MySampleSources
15:10:29.722 INFO  - Load module settings
15:10:29.994 INFO  - Load rules
15:10:30.192 INFO  - Base dir: /root
15:10:30.192 INFO  - Working dir: /root/.sonar
15:10:30.193 INFO  - Source paths: MySampleSources
15:10:30.193 INFO  - Source encoding: UTF-8, default locale: en
15:10:30.194 INFO  - Index files
15:10:30.640 INFO  - 627 files indexed
15:10:33.035 INFO  - Quality profile for java: Sonar way
15:10:33.052 INFO  - Sensor JavaSquidSensor
15:10:33.387 INFO  - Java Main Files AST scan...
15:10:33.390 INFO  - 627 source files to be analyzed
15:10:43.391 INFO  - 461/627 files analyzed, current is /root/MySampleSources/2.0.2-SNAPSHOT/oc-server-session-agent-services/src/main/java/com/indigo/oc/session/agent/service/DeviceAliasHelper.java
15:10:46.360 INFO  - Java Main Files AST scan done: 12973 ms
15:10:46.360 INFO  - 627/627 source files analyzed
15:10:46.361 WARN  - Java bytecode has not been made available to the analyzer. The org.sonar.java.bytecode.visitor.DependenciesVisitor@1539e85, org.sonar.java.checks.UnusedPrivateMethodCheck@239ee8b6, org.sonar.java.checks.RedundantThrowsDeclarationCheck@29cf4f43 are disabled.
15:10:46.361 INFO  - Java Test Files AST scan...
15:10:46.362 INFO  - 0 source files to be analyzed
15:10:46.362 INFO  - Java Test Files AST scan done: 1 ms
15:10:46.362 INFO  - 0/0 source files analyzed
15:10:46.655 INFO  - Sensor JavaSquidSensor (done) | time=13603ms
15:10:46.655 INFO  - Sensor Lines Sensor
15:10:46.671 INFO  - Sensor Lines Sensor (done) | time=16ms
15:10:46.672 INFO  - Sensor QProfileSensor
15:10:46.675 INFO  - Sensor QProfileSensor (done) | time=3ms
15:10:46.675 INFO  - Sensor InitialOpenIssuesSensor
15:10:47.528 INFO  - Sensor InitialOpenIssuesSensor (done) | time=853ms
15:10:47.528 INFO  - Sensor ProjectLinksSensor
15:10:47.534 INFO  - Sensor ProjectLinksSensor (done) | time=6ms
15:10:47.535 INFO  - Sensor VersionEventsSensor
15:10:47.545 INFO  - Sensor VersionEventsSensor (done) | time=10ms
15:10:47.546 INFO  - Sensor SurefireSensor
15:10:47.546 INFO  - parsing /root/target/surefire-reports
15:10:47.546 WARN  - Reports path not found: /root/target/surefire-reports
15:10:47.546 INFO  - Sensor SurefireSensor (done) | time=0ms
15:10:47.546 INFO  - Sensor SCM Sensor
15:10:47.547 INFO  - No SCM system was detected. You can use the 'sonar.scm.provider' property to explicitly specify it.
15:10:47.547 INFO  - Sensor SCM Sensor (done) | time=1ms
15:10:47.547 INFO  - Sensor CPD Sensor
15:10:47.547 INFO  - JavaCpdEngine is used for java
15:10:47.549 INFO  - Cross-project analysis disabled
15:10:48.168 INFO  - Sensor CPD Sensor (done) | time=621ms
15:10:48.170 INFO  - No quality gate is configured.
15:10:48.203 INFO  - Compare to previous analysis (2015-06-24)
15:10:48.208 INFO  - Compare over 30 days (2015-05-25, analysis of Tue Jun 23 21:57:46 UTC 2015)
15:10:48.359 INFO  - Execute decorators...
15:10:52.918 INFO  - Store results in database
15:11:01.523 INFO  - Analysis reports generated in 203ms, dir size=1 MB
15:11:01.875 INFO  - Analysis reports compressed in 351ms, zip size=896 KB
15:11:01.923 INFO  - Analysis reports sent to server in 48ms
15:11:01.923 INFO  - ANALYSIS SUCCESSFUL, you can browse http://localhost:9000/dashboard/index/MySampleSources
15:11:01.923 INFO  - Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report.
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
Total time: 36.655s
Final Memory: 13M/252M
INFO: ------------------------------------------------------------------------
```

### 2.2. Browse the Analysis

- SonarQube Web front end from host browser: http://sonarqube.zenentropy.net:9000

	> No need to be logged in to browse an analysed project (public access)

- MySampleSources project should be listed in the Project folder, select it and navigate...

	> Direct URL: http://sonarqube.zenentropy.net:9000/dashboard/index/MySampleSources

<br>
<br>
## 3. TBD

1. _SourceMeter Plugin:_

	- https://www.sourcemeter.com/
	- https://github.com/FrontEndART/SonarQube-plug-in
	- http://conferences.computer.org/scam/2014/papers/6148a077.pdf
	- http://stackoverflow.com/questions/5479019/is-sonar-replacement-for-checkstyle-pmd-findbugs
	- https://wikis.forgerock.org/confluence/display/QA/Security+Testing
