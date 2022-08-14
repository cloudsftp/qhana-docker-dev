# QHAna Docker Compose for Developers

![version](https://img.shields.io/badge/Version-v0.1.1--pre-blue)


This repo aims to ease the development of
- the plugin runner,
- the wroker,
- plugins, and
- the UI

## Initialize Submodules

Run in the root of this project:

```
# init submodules
git submodule init

# pull latest changes to the submodules
git submodule update
```

Inside the submodules you can use `git` just like in a normal repo.
The default remotes are
- `git@github.com:UST-QuAntiL/qhana-plugin-runner.git` and
- `git@github.com:UST-QuAntiL/qhana-ui.git`
- `git@github.com:UST-QuAntiL/nisq-analzer-ui.git`

You can change them to the `http` alternatives if you have connection issues.
Just run 
```
git remote set-url origin https://github.com/UST-QuAntiL/qhana-plugin-runner.git
```
inside the submodule.

## Usage

```
Usage: ./start.sh [MODE] [OPTIONS]

MODE:
     <empty>              For development mode
     docker               For docker mode

OPTIONS for development mode:
   --no-ui                Does not start the user interface
   --no-worker            Does not start the worker
   --no-plugin-runner     Does not start the plugin runner
   --no-nisq-ui           Does not start the user interface for the nisq analyzer

OPTIONS for docker mode:
   --rebuild-runner       Rebuilds qhana-plugin-runner (the same image is used for the worker)
   --rebuild-ui           Rebuilds qhana-ui
   --rebuild-nisq-ui      Rebuilds nisq-analyzer-ui
   --rebuild | -r         Rebuilds all services
```

### Modes

There are two modes:
- development and
- docker

#### Development

```
./start.sh [OPTIONS]
```

Starts the user interface, plugin runner, and worker on the localhost.
While running the backend in a docker container.

This allows for live reloads of the user interface and plugin runner when you are editing the code.

The output of the user interface, plugin runner, and worker are written to log files.
The output of the docker containers are displayed in the console.

Plugins are loaded from `./qhana-plugin-runner/plugins`
The UI then is accessable at [http://localhost:4200](http://localhost:4200).

##### Options

```
OPTIONS for development mode:
   --no-ui                Does not start the user interface
   --no-worker            Does not start the worker
   --no-plugin-runner     Does not start the plugin runner
   --no-nisq-ui           Does not start the user interface for the nisq analyzer
```

#### Docker

```
./start.sh docker [OPTIONS]
```

Starts everything in a docker container.
This is intended for final testing.

Plugins are loaded from `./qhana-plugin-runner/plugins`
The UI then is accessable at [http://localhost:4200](http://localhost:4200).

##### Options

```
OPTIONS for docker mode:
   --rebuild-runner       Rebuilds qhana-plugin-runner (the same image is used for the worker)
   --rebuild-ui           Rebuilds qhana-ui
   --rebuild-nisq-ui      Rebuilds nisq-analyzer-ui
   --rebuild | -r         Rebuilds all services
```

### IBMQ Token

Copy the file `_docker-compose.ibmq.yml` to `docker-compose.ibmq.yml` and put your token in the new file.

## Haftungsausschluss

Dies ist ein Forschungsprototyp.
Die Haftung für entgangenen Gewinn, Produktionsausfall, Betriebsunterbrechung, entgangene Nutzungen, Verlust von Daten und Informationen, Finanzierungsaufwendungen sowie sonstige Vermögens- und Folgeschäden ist, außer in Fällen von grober Fahrlässigkeit, Vorsatz und Personenschäden, ausgeschlossen.

## Disclaimer of Warranty

Unless required by applicable law or agreed to in writing, Licensor provides the Work (and each Contributor provides its Contributions) on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied, including, without limitation, any warranties or conditions of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE.
You are solely responsible for determining the appropriateness of using or redistributing the Work and assume any risks associated with Your exercise of permissions under this License.

