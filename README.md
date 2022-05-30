# QHAna Docker Compose for Developers

![version](https://img.shields.io/badge/Version-v0.0.2-blue)


This repo aims to ease the development of
- plugins and
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

You can change them to the `http` alternatives if you have connection issues.
Just run 
```
git remote set-url origin https://github.com/UST-QuAntiL/qhana-plugin-runner.git
```
inside the submodule.

## Start QHAna

```
./start
```

- Starts `qhana-ui` with live updates
- Starts docker compose for `qhana-backend`, `qhana-plugin-runner`, etc.
- Plugins are loaded live from `./qhana-plugin-runner/plugins`

The UI then is accessable at [http://localhost:4200](http://localhost:4200).

### Options

```
OPTIONS:

   --rebuild-runner       Rebuilds qhana-plugin-runner
   --rebuild | -r         Rebuilds all services
```

## Haftungsausschluss

Dies ist ein Forschungsprototyp.
Die Haftung für entgangenen Gewinn, Produktionsausfall, Betriebsunterbrechung, entgangene Nutzungen, Verlust von Daten und Informationen, Finanzierungsaufwendungen sowie sonstige Vermögens- und Folgeschäden ist, außer in Fällen von grober Fahrlässigkeit, Vorsatz und Personenschäden, ausgeschlossen.

## Disclaimer of Warranty

Unless required by applicable law or agreed to in writing, Licensor provides the Work (and each Contributor provides its Contributions) on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied, including, without limitation, any warranties or conditions of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE.
You are solely responsible for determining the appropriateness of using or redistributing the Work and assume any risks associated with Your exercise of permissions under this License.

