<div id="top-header" style="with:100%;height:auto;text-align:right;">
    <img src="./resources/docs/images/pr-banner-long.png">
</div>

# INFRASTRUCTURE PLATFORMS

[![Generic badge](https://img.shields.io/badge/version-1.0-blue.svg)](https://shields.io/)
[![Open Source? Yes!](https://badgen.net/badge/Open%20Source%20%3F/Yes%21/blue?icon=github)](./)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

# Nginx + NodeJS 24
<br>

This Infrastructure Platform repository is designed for back-end projects and provides three separate platforms:

## Platforms for Full-Stack Project

- API: [Nginx + NodeJS 24](./platforms/nginx-nodejs-24/README.md)
<br><br>


## Index

- [Repository Objetives](#repository-objetives)
- [Requirements](#requirements)
- [Containers Networking](#container-networking)
- [Requirements](#requirements)
- [Containers Networking](containers-networking)
- [Platforms Settings](#platforms-setup)
- [Platform Start Up](#platforms-startup)
- [Using this Repository for Custom Project](#platform-usage)
<br><br>

## <a id="repository-objetives"></a>Repositoy Objetives

### Key principles and goals

This repository provides a consistent framework for local development that mirrors production environments. In production, APIs run on cloud instances (AWS, Azure, GCP) or Kubernetes pods. Meanwhile, the database layer resides on managed services like AWS RDS, Azure Database, or GCP Cloud SQL, utilizing Multi-AZ deployments for high availability and read replicas to scale performance. This structure ensures network connections between application and database tiers remain decoupled.

By leveraging Platform Engineering principles, this project reduces cognitive load for developers. It treats the Internal Developer Platform (IDP) as a product, offering self-service tools and automated workflows. This streamlines the entire lifecycle—from building to monitoring—allowing teams to innovate faster.

- **Self-service:** Provide developers with easy-to-use tools and automated workflows to manage their own infrastructure needs without having to file tickets or rely on other teams.

- **Standardization:** Use standardized tools and environments to ensure consistency, reliability, and security across projects.

- **Reduced cognitive load:** Abstract away underlying complexity so developers can focus on writing code and delivering business value rather than managing infrastructure details.

- **Developer experience:** Build a positive and productive environment for developers, making them feel empowered and less frustrated.

- **Operational efficiency:** Automate repetitive tasks and standardize processes to improve the speed and reliability of software delivery.

### How it works

- Internal Developer Platform (IDP): A dedicated platform built by the platform engineering team that provides a curated set of tools, services, and infrastructure.

- Golden Paths: Predefined, optimized workflows and best practices that developers can follow to accomplish common tasks quickly and easily.

- Treating the platform as a product: Platform engineers treat their IDP like a product, with developers as their customers, to ensure it meets the needs of the organization.
<br>

### Read more:

- [What is platform engineering? - IBM](https://www.ibm.com/think/topics/platform-engineering)
- [Understanding platform engineering - Red Hat](https://www.redhat.com/en/topics/platform-engineering)
- [Platform engineering - Prescriptive Guidance - AWS](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-caf-platform-perspective/platform-eng.html)
- [What is an internal developer platform (IDP)? - Google Cloud](https://cloud.google.com/solutions/platform-engineering)
- [What is platform engineering? - Microsoft](https://learn.microsoft.com/en-us/platform-engineering/what-is-platform-engineering)
- [What is Platform engineering? - Github](https://github.com/resources/articles/what-is-platform-engineering)
<br><br>

## <a id="requirements"></a>Requirements

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![MacOS](https://img.shields.io/badge/MacOS-f0f0f0?logo=apple&logoColor=black&style=for-the-badge)
![gnu](https://img.shields.io/badge/gnu-%23A42E2B.svg?style=for-the-badge&logo=gnu&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

Despite Docker’s cross-platform compatibility, for intermediate to advanced software development on environments other than Windows NT or macOS, automating the platform build and streamlining the process of starting feature development is crucial. This automation enables a more dynamic and efficient software development lifecycle.

- Docker
- Docker Compose
- GNU Make *(otherwise commands must be executed manually)*

| Dev machine   | Machine's features                                                                            |
| ------------- | --------------------------------------------------------------------------------------------- |
| CPU           | Linux *(x64 - x86)* /  MacOS Intel *(x64 - x86)*, or M1                                       |
| RAM           | *(for this container)*: 128 MB minimum.                                                       |
| DISK          | 1 GB *(though is much less, its usage could be incremented depending on the project usage)*.  |
<br>

## <a id="containers-networking"></a>Containers Networking - Access Modes

- If no application is on `./application` directory *(or your custom binded directory name)* once container is up it wont provide a application and therefore Apache will respond with an error. Copy an start-up example application or create a parking page.

- Each container have a directory to set the required environment values in `./docker/.env` from `./docker/.env.example` if no GNU Make will be applied.

- Also, each container may need to set the required configuration files by coping and updating them depending on your project requirements.

- Containers availability by building the container with `docker-composer.yml` in separated configuration layers
    - Stand-alone
        - The container is intended to be published directly and accessed from the host network, typically via `0.0.0.0:<port>`. It does not require a shared Docker network. It is a common setting for local development.
    - Inside a Custom Network
        - The container is attached to a custom Docker network and is intended to be accessed through a reverse proxy or other containers on the same network.
        - This network setting is useful for isolating services while still allowing container-to-container communication.
        - It is a strongly recommended setting for remote deployment to avoid exposing the localhost port in used and protect by firewall.
        - <b>Connect from one container to another inside the custom network, by container name and its own exposed port</b>.
    - Host-Gateway
        - The container can reach services running on the host machine using the Docker host gateway mapping. This is useful when the container must access local services on the VPS/host, while public access is still handled through a reverse proxy. It is a recommended setting for remote deployment too.
    - Public exposure is controlled by the `ports` mapping.
    - `0.0.0.0:<port>` means externally accessible.
    - `127.0.0.1:<port>` means local-only access on the host and requires a reverse proxy, e.g. Apache.
    - Docker network attachment controls container-to-container communication.
    - Host-gateway controls container-to-host communication.
<br><br>

## <a id="platforms-setup"></a>Configure Platforms

Create the root `./.env` file from the [./.env.example](./.env.example) and follow its description to configure the platforms. Each variable has its own explanation.

Also create the root `./Makefile` file from [./resources/automation/local/Makefile](./resources/automation/local/Makefile) so it will be easy to manage the platforms from one location in the project.

Each recipe has its own explanation or execute `make help` command to see them all. This streamlines the workflow for managing containers with mnemonic recipe names, avoiding the effort of remembering and typing each bash command line:
```bash
$ make help
```

Once variables set, each Docker platform container environment variables can be set by GNU Make recipes placed in the root of this repository:

- Set up the API container
  ```bash
  $ make apirest-set
  ```
  **Remember**: *the `./application` directory name is custimizable for binding between the container and local machine.*

- Set up the database container
  ```bash
  $ make db-set
  ```

- Set up the mail service container
  ```bash
  $ make mailer-set
  ```

- Set up the message broker service container
  ```bash
  $ make broker-set
  ```
<br>

## <a id="platforms-startup"></a>Start Up Platforms

Create and start up the API container
```bash
$ make apirest-create
```
<br>

Testing container visiting localhost with the assigned port, but with no database connection established or failed because of wrong configuration
<br>

Create and start up the database container
```bash
$ make db-create
```
<br>

Once database service is up and running, status message will show successful connection
<br>

Create and start up the mail service container
```bash
$ make mailer-create
```
<br>

Create and start up the message broker service container
```bash
$ make broker-create
```
<br>

Test mail service container by clicking "Direct Test MAIL" link
<br>

Docker information of both cointer up and running
```bash
$ sudo docker ps
```
<br>

Despite each container can be stop or restarted, they can be stop and destroy both containers simultaneously to clean up locally from Docker generated cache, without affecting other containers running on the same machine.
```bash
$ yes | make apirest-destroy db-destroy mailer-destroy broker-destroy
```
<br><br>

## <a id="platform-usage"></a>Use this Platform Repository for your own REST API repository

Repository directories structure overview
```sh
.
├── application                 # detached repository
│   ├── src
│   ├── .env
│   ├── vendor
│   └── ...etc
│
├── platforms                   # remote infrastructure platforms
│   └── nginx-nodejs-24
│       ├── docker
│       │   ├── config
│       │   ├── .env
│       │   ├── docker-compose.yml
│       │   └── Dockerfile
│       └── Makefile
│
├── resources                   # orientative documentation
│   ├── automation
│   │   ├── local
│   │   │   ├── Makefile        # root ./
│   │   │   └── Makefile.child  # this goes inside ./application
│   │   └── remote
│   └── docs
│       └── ...
│
├── .env
├── Makefile
└── README.md
```
<br>

Set up platforms
- Copy `.env.example` to `.env` and adjust settings (rest api port, database port, mail service port, container RAM usage, etc.)
<br>

### Managing the `apirest` Directory: Submodule vs Detached Repository

To remove the `./application` directory with the default installation content and install your desired repository inside it, there are two alternatives for managing both the platform and apirest repositories independently:

Here’s a step-by-step guide for using this Platform repository along with your own REST API repository:

- Remove the existing `./application` directory contents from local and from git cache
- Install your desired repository inside `./application`
- Choose between Git submodule and detached repository approaches

#### 1. **GIT Detached Repository (Recommended)**

> Git commands can be executed **whether from inside the container or on the local machine**.

- Remove `application` from local and git cache:
  ```bash
  $ git rm -r --cached -- "application/*" ":(exclude)application/.gitkeep"
  $ git clean -fd
  $ git reset --hard
  $ git commit -m "maint: application directory and its default installation removed"
  ```

- Clone the desired repository as a detached repository:
  ```bash
  $ git clone git@[vcs]:[account]/[repository].git ./application
  ```

- The `./application` directory is now an **independent repository**, not tracked as a submodule in your main repo. You can use `git` commands freely inside `application` from anywhere.
<br>

#### 2. **GIT Sub-module**

> Git commands can be executed **only from inside the container**.

- Remove `application` from local and git cache:
  ```bash
  $ rm -rfv ./application/* ./application/.[!.]*$
  $ git rm -r --cached application
  $ git commit -m "maint: application directory and its default installation removed"
  ```

- Add the desired repository as a submodule:
  ```bash
  $ git submodule add git@[vcs]:[account]/[repository].git ./application
  $ git commit -m "maint: application as a git submodule added"
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

#### **Summary Table**

| Approach         | Repo independence | Where to run git commands | Use case                        |
|------------------|------------------|--------------------------|----------------------------------|
| Submodule        | Tracked by main  | Inside container         | Main repo controls webapp version|
| Detached (rec.)  | Fully independent| Local or container       | Maximum flexibility              |

> **Note**: After new project cloned inside `./application`, consider adding `./application/.gitkeep` in it to prevent accidental tracking *(especially for detached repository)*.
<br><br>

<br>

## Contributing

Contributions are very welcome! Please open issues or submit PRs for improvements, new features, or bug fixes.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -am 'feat: Add new feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Create a new Pull Request
<br><br>

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