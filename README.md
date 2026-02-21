<div id="top-header" style="with:100%;height:auto;text-align:right;">
    <img src="./resources/docs/images/pr-banner-long.png">
</div>

# INFRASTRUCTURE PLATFORM NODEJS 25

## Repository Overview

This Infrastructure Platform repository provides a dedicated Node.js stack for front-end projects, enabling developers to work within a consistent local development framework that closely mirrors real-world deployment scenarios. Whether your application will run on **AWS EC2**, **Google Cloud GCE**, **Azure** instances, **VPS** or be distributed across **Kubernetes pods**, this structure ensures smooth transitions between environments.

### Modular and Decoupled Design

A key feature of this repository is its modular design: it is intentionally decoupled from its sub-directory `./application`, allowing the platform to be maintained independently without impacting the associated subproject. This separation supports dedicated upkeep and flexibility for both the platform and its detached web application.

### Multi-instance Local Development

Additionally, the platform is designed to support running multiple development versions of the `./application` simultaneously, simply by adjusting a few environment settings to differentiate each container instance. It is highly configurable to accommodate various infrastructure or machine requirements, allowing developers to easily tailor parameters such as container RAM allocation, port assignments, and other platform settings to best fit their local or deployment environment.
<br>

## Content of this page:

- [Requirements](#requirements)
- [Platform Features](#platform-features)
- [Container Environment Settings](#setup-containers)
- [Build and run the Web Application Container](#create-containers)
- [GNU Make file recipes](#make-help)
- [Use this Platform Repository for your Web Application Project](#platform-usage)
<br><br>

## <a id="requirements"></a>Requirements

Despite Docker’s cross-platform compatibility, for intermediate to advanced software development on environments other than Windows NT or macOS, automating the platform build and streamlining the process of starting feature development is crucial. This automation enables a more dynamic and efficient software development lifecycle.

- **Docker**: Containerizes applications for consistent environments.
- **Docker Compose**: Manages multi-container setups and dependencies.
- **GNU Make**: Automates build commands and workflows *(otherwise, commands must be executed manually)*.

If you won't use GNU Make, Docker commands will have to be executed from within the `./platform/nginx-nodejs-25/docker` directory.

| Dev machine   | Machine's features                                                                            |
| ------------- | --------------------------------------------------------------------------------------------- |
| CPU           | Linux *(x64 - x86)* /  MacOS Intel *(x64 - x86)*, or M1                                       |
| RAM           | *(for this container)*: 1 GB minimum.                                                         |
| DISK          | 2 GB *(though is much less, it usage could be incremented depending on the project usage)*.   |
<br>

## <a id="platform-features"></a>Platform Features

It can be installed the most known JS **front-end** frameworks:

- [React](https://react.dev/)
- [Angular](https://angular.dev/) *(Container requires at least 1GB RAM)*
- [Vue3](https://vuejs.org/)
- [Svelte](https://svelte.dev/)
- Others...
<br>

Take into account that each framework will demand its specific configuration from inside container.
<br><br>

## <a id="setup-containers"></a>Container Environment Settings

The container instance has its dedicated GNU Make and the core Docker directory which contains the scripts and stack assets to build the required platform configuration.

Also, there is a copy at `./resources/application/` directory to contain the exact or the alternated scripts, so you can save or backup the different SDLC required configuration *(e.g. Testing, Staging, Production)*.

**Stack:**
- Linux Alpine version 3.23
- NGINX version 1.28 *(or the latest on Alpine Package Keeper)*
- NodeJS 25 with NPM and YARN installed
<br><br>

> **Note**: There is a `./platform/nginx-nodejs-25/docker/.env.example` file with the variables required to build the container by `docker-compose.yml` file to create the container if no GNU Make is available on developer's machine. Otherwise, it is not required to create its `.env` manually file for building the container. web app environment: `./platform/nginx-nodejs-25/docker/.env`

```bash
COMPOSE_PROJECT_LEAD="myproj"
COMPOSE_PROJECT_CNET="mp-dev"
COMPOSE_PROJECT_IMGK="alpine3.22-nginx1.26-njs22.16"
COMPOSE_PROJECT_NAME="mp-app-dev"
COMPOSE_PROJECT_HOST="127.0.0.1"
COMPOSE_PROJECT_PORT=7501
COMPOSE_PROJECT_PATH="../../../application"
COMPOSE_PROJECT_MEM="512M"
COMPOSE_PROJECT_SWAP="1G"
COMPOSE_PROJECT_USER="myproj"
COMPOSE_PROJECT_GROUP="myproj"
```

<span style="color: green;"><b>Using GNU Make</b></span> from root directory to configure the container environment, create the root `./.env` file from the [./.env.example](./.env.example) and follow its variables description to set the correct values. The end result would be like this:
```bash
# REMOVE COMMENTS WHEN COPY THIS FILE AND TRIM TRAILING WHITESPACES
# Ask the team for recommended values

# DOCKER VARIABLES FOR AUTOMATION
SUDO=sudo                                               # <- how local user executes system commands - leave it empty if not necessary ----------------------> #
DOCKER=sudo docker                                      # <- how local user executes Docker commands --------------------------------------------------------> #
DOCKER_COMPOSE=sudo docker compose                      # <- how local user executes "docker compose" or docker-compose command -----------------------------> #

# CONTAINERS BASE INFORMATION FOR BUILDING WITH docker-compose.yml
PROJECT_NAME="PLATFORMS DOCKER"                         # <- project name will be used for automation outputs -----------------------------------------------> #
PROJECT_LEAD=abbr                                       # <- abbreviation or acronym name as part of the container tag that is useful relationship naming ---> #
PROJECT_HOST="127.0.0.1"                                # <- machine hostname referrer - not necessary for this project -------------------------------------> #
PROJECT_CNET=mp-dev                                     # <- useful when a network is required for container connections between each other -----------------> #

# WEBAPP - LOCAL
WEBAPP_PLTF=nginx-nodejs-25                             # <- platform assets directory's name ---------------------------------------------------------------> #
WEBAPP_IMGK=alpine3.23-nginx-nodejs25                   # <- real main image keys to manage automations for sharing resources -------------------------------> #
WEBAPP_PORT=7001                                        # <- local machine port opened for container service ------------------------------------------------> #
WEBAPP_BIND="../../../application"                      # <- path where application is binded from container to local ---------------------------------------> #
WEBAPP_CAAS=mp-app-dev                                  # <- container name to build the service - it is important to set the environment in this variable --> #
WEBAPP_CAAS_USER=osuser                                 # <- container's project directory user -------------------------------------------------------------> #
WEBAPP_CAAS_GROUP=osgroup                               # <- container's project directory group ------------------------------------------------------------> #
WEBAPP_CAAS_CPUS=2.00                                   # <- container's maximum CPUs usage to apply by docker-compose - leave it empty for full usage ------> #
WEBAPP_CAAS_MEM=128M                                    # <- container's maximum RAM usage to apply by docker-compose ---------------------------------------> #
WEBAPP_CAAS_SWAP=512M                                   # <- container's RAM swap space in storage executed by automation command ---------------------------> #
```

Once the environment file is set, create each Docker environment file by the automated commands using GNU Make:

Set up the web application container
```bash
$ make webapp-set
```

Watch the local hostname IP on which Docker serves and the ports assigned, even though the web app can be accessed through `http://127.0.0.1` or `http://localhost`
```bash
$ make local-hostname
```

## <a id="create-containers"></a>Build and run the Web Application Container

For custom configurations, there is a `./platform/nginx-nodejs-25/docker/config/supervisor/conf.d-sample` directory with **Supervisord** services. Copy the main two services required for the **application** container startup.
```bash
$ cd ./platform/nginx-nodejs-25/docker/config/supervisor
$ cp -vn conf.d-sample/nginx.conf conf.d-sample/index.conf conf.d/
'conf.d-sample/nginx.conf' -> 'conf.d/nginx.conf'
'conf.d-sample/index.conf' -> 'conf.d/index.conf'
```

<span color="orange"><b>IMPORTANT:</b></span> Before building the container, the Nginx server block serves at port 80 proxing to port 8080 to be handled by NodeJS. On first installation will throw 404 error if no project is developed inside.

```
NGINX 404 ERROR
```
<br>

To preview the successful installation on browser, there is a basic landing page sample at `./resources/application-sample/`. Copy its content into `./application` directory
```bash
$ cp -a ./resources/application-sample/. ./application
```

Create and start up the web app container
```bash
$ make webapp-create
```
<br>

For any further change in the binded `./application` directory, access into the container to install require NodeJS packages and restart the container
```bash
$ make webapp-ssh

/var/www $ npm install

# Option 1: restart Supervisord service that runs nodejs
/var/www $ sudo supervisorctl restart index # service that runs node --watch /var/www/index.js

# Option 2: restart container
/var/www $ exit

$ make webapp-restart
```
<br>

Now you can see on browser the NodeJS application running
<br>

Docker information of both cointer up and running
```bash
$ sudo docker ps -a
$ sudo docker stats
```
<br>

Also there is a **useful GNU Make recipe** to see the container relevant information. This is important when project is in **dev mode** inside the container. So, you would see the framework development stage on Docker IP port, e.g. `http://172.18.0.2:3000` - *NOT ON YOUR MACHINE LOCALHOST - 127.0.0.1*

Output example:
```bash
$ make webapp-info

PLATFORMS DOCKER: NGINX - NODEJS 25
Container ID.: 6dcc29b09476
Name.........: abbr-mp-app-dev                              # container name
Image........: abbr-mp-app-dev:alpine3.23-nginx-nodejs25    # container image
CPUs.........: 2.00                                         # max. cpus uses the container from local machine
RAM..........: 256M                                         # max. memory uses the container from local machine
Swap.........: 512M                                         # swap memory on container's volume
Host.........: 127.0.0.1:7001                               # address binded to container port 80
Hostname.....: 192.168.1.41:7001                            # local hostname
Docker.Host..: 172.18.0.2                                   # Docker IP
NetworkID....: 8cf47eba68e3fabc1365de3eaff0330c22ee8519e34dd338a791d2ca7d40768f
```
<br>

Despite the container can be stop or restarted, it can be stop and destroy to clean up locally from Docker generated cache, without affecting other containers running on the same machine.
```bash
$ make webapp-destroy
```
<br>

## <a id="make-help"></a>GNU Make file recipes

The project's main `./Makefile` contains recipes with the commands required to manage each platform's Makefile from the project root.

This streamlines the workflow for managing the container with mnemonic recipe names, avoiding the effort of remembering and typing each bash command line.
```bash
$ make help
Usage: $ make [target]
Targets:
$ make help                           shows this Makefile help message
$ make local-hostname                 shows local machine ip and container ports set
$ make local-ownership                shows local ownership
$ make local-ownership-set            sets recursively local root directory ownership
$ make webapp-hostcheck               shows this project ports availability on local machine for application container
$ make webapp-info                    shows the application docker related information
$ make webapp-set                     sets the application enviroment file to build the container
$ make webapp-create                  creates the application container from Docker image
$ make webapp-network                 creates the application container network - execute this recipe first before others
$ make webapp-ssh                     enters the application container shell
$ make webapp-start                   starts the application container running
$ make webapp-stop                    stops the application container but its assets will not be destroyed
$ make webapp-restart                 restarts the running application container
$ make webapp-destroy                 destroys completly the application container
$ make repo-flush                     echoes clearing commands for git repository cache on local IDE and sub-repository tracking remove
$ make repo-commit                    echoes common git commands
```
<br>

## <a id="platform-usage"></a>Use this Platform Repository for your Web Application Project

Platform Documentation:

- [NGINX + NODEJS 25](./platform/nginx-nodejs-25/README.md)
<br><br>

Repository directories structure overview:
```
.
├── application (Vue, Angular, React, Svelte, etc.)
│   ├── node_modules
│   ├── index.js
│   ├── package.json
│   └── ...
│
├── platform
│   └── nginx-nodejs
│       ├── docker
│       │   │   ├── nginx
│       │   │   └── supervisord
│       │   ├── config
│       │   ├── .env
│       │   ├── docker-compose.yml
│       │   └── Dockerfile
│       │
│       └── Makefile
├── .env
├── Makefile
└── README.md
```
<br>

Here’s a step-by-step guide for using this Platform repository along with your own web application:

- Remove the existing `./application` directory contents from local and from git cache
- Install your desired repository inside `./application`
- Choose between Git submodule and detached repository approaches
<br>

## Managing the `application` Directory: Submodule vs Detached Repository

To remove the `./application` directory with the default installation content and install your desired repository inside it, there are two alternatives for managing both the platform and application repositories independently:

### 1. **GIT Sub-module**

> Git commands can be executed **only from inside the container**.

- Remove `application` from local and git cache:
  ```bash
  $ rm -rfv ./application/* ./application/.[!.]*$
  $ git rm -r --cached application
  $ git commit -m "Remove application directory and its default installation"
  ```

- Add the desired repository as a submodule:
  ```bash
  $ git submodule add git@[vcs]:[account]/[repository].git ./application
  $ git commit -m "Add application as a git submodule"
  ```

- To update submodule contents:
  ```bash
  $ cd ./application
  $ git pull origin main  # or desired branch
  ```

- To initialize/update submodules after `git clone`:
  ```bash
  $ git submodule update --init --recursive
  ```

---

### 2. **GIT Detached Repository (Recommended)**

> Git commands can be executed **whether from inside the container or on the local machine**.

- Remove `application` from local and git cache:
  ```bash
  $ rm -rfv ./application/* ./application/.[!.]*
  $ git rm -r --cached application
  $ git clean -fd
  $ git reset --hard
  $ git commit -m "Remove application directory and its default installation"
  ```

- Clone the desired repository as a detached repository:
  ```bash
  $ git clone git@[vcs]:[account]/[repository].git ./application
  ```

- The `application` directory is now an **independent repository**, not tracked as a submodule in your main repo. You can use `git` commands freely inside `application` from anywhere.

---

#### **Summary Table**

| Approach         | Repo independence | Where to run git commands | Use case                               |
|------------------|-------------------|---------------------------|----------------------------------------|
| Submodule        | Tracked by main   | Inside container          | Main repo controls application version |
| Detached (rec.)  | Fully independent | Local or container        | Maximum flexibility                    |

---

Once the container is up, Supervisor will run the sample web application script. See `./platform/nginx-nodejs-25/docker/config/supervisor/conf.d/nodejs.conf`
```bash
[program:nodejs]
command=node --watch /var/www/index.js
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
autorestart=false
startretries=0
```

> **Note**: If web application main script is other, remember to modify this file or use the other examples.

> After switching to either alternative, consider adding `/application` to your `.gitignore` in this main platform repository to prevent accidental tracking *(especially for detached repository)*.

<br>

---

## Contributing

Contributions are very welcome! Please open issues or submit PRs for improvements, new features, or bug fixes.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -am 'feat: Add new feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Create a new Pull Request

---

## License

This project is open-sourced under the [MIT license](LICENSE).

<!-- FOOTER -->
<br>

---

<br>

- [GO TOP ⮙](#top-header)

<div style="with:100%;height:auto;text-align:right;">
    <img src="./resources/docs/images/pr-banner-long.png">
</div>