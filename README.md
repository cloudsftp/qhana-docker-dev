# QHAna Docker Compose for Developers

This repo aims to ease the development of
- plugins and
- the UI

## Initialize Submodules

Run in the root of this project:
- `git submodule init`
- `git submodule update`

Inside the submodules you can use `git` just like in a normal repo.
The deafault remotes are
- `git@github.com:UST-QuAntiL/qhana-plugin-runner.git` and
- `git@github.com:UST-QuAntiL/qhana-ui.git`

You can change them to the `http` alternatives if you have connection issues.
Just run `git remote set-url origin https://github.com/UST-QuAntiL/qhana-plugin-runner.git` inside the submodule.

## Start QHAna

```
docker-compose --profile with_db up
```
