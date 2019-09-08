# dotfiles

Preferences and settings for my toolbox.

* Code Style - Code styles IntelliJ IDEA
* Color Schemes - Color schemes for IntelliJ IDEA with previews
* Modules - Powershell modules
* Scripts - Some tooling
* Templates - Repetitive boilerplate for new projects

Shell prompt:

- Shell starts in a predefined directory ([`INITIAL_CWD` in `~\.env`](.env.sample)).
- When the shell starts it makes a backup of environment variable `PATH` to `~\.path.txt`.
- Displays current time.
- Displays explicit name of the current shell. (Set `$env:PSPromptName` to name the shell.)
- Displays currently activated Python virtual environment and Node.js interpreter.
- Displays current WSL distribution and user.
- Displays current AWS CLI profile. (Set `$env:AWS_DEFAULT_PROFILE` to switch between profiles.)
- Displays only name of the current directory, and not its full path (configurable via [`$env:PSPromptSettings.FullPath`](prompt.psm1)).
- Displays git status - working tree state, current branch and number of commits behind and ahead.
- All of the info above can be hidden via [`$env:PSPromptSettings.Compact`](prompt.psm1).
- Automatically activates Python virtual environment (only venv) on entering a directory, if it or any of its parents contains a venv located in subdirectory `.venv`, and deactivates it on entering a directory that does not satisfy such condition.
- Automatically activates Node.js interpreter on entering a directory, if it or any of its parents contains a file `.nvmrc` with a version of the desired Node.js interpreter, and deactivates it on entering a directory that does not satisfy such condition.
- Automatically binds `wsl` command to appropriate distribution and user on entering a directory, if it or any of its parents contains a file `.wslrc` with a name of the desired WSL distribution to be used, and roll backs to default `wsl` command on entering a directory that does not satisfy such condition.

Example:

```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Changes in $env:PATH: None

python  C:\tools\python37\python.exe
pip     C:\tools\python37\Scripts\pip.exe
node    C:\Users\jakub\AppData\Roaming\nvm\v12.5.0\node.exe
npm     C:\Users\jakub\AppData\Roaming\nvm\v12.5.0\npm.cmd

Loading personal and system profiles took 1357ms.
19:38:06 [py@cool-project | node@cool-company#12] (AWS Profile Name) web [master 1→] $
```

## Utilities

### `pip-do` - venv-aware pip

[`pip-do` (alias to `Invoke-PipDo`)](Modules/Invoke-PipDo/Invoke-PipDo.psm1) is a tiny wrapper around `pip`.
It has the same interface as `pip`, but it ensures that you're always working inside a virtual environment.

```console
$ ls -Name
$ pip-do install attrs
Python 3.7.3
Virtual environment does not exist. Creating new one ...
Running pip install attrs ...
Collecting attrs
  Using cached https://files.pythonhosted.org/packages/23/96/d828354fa2dbdf216eaa7b7de0db692f12c234f7ef888cc14980ef40d1d2/attrs-19.1.0-py2.py3-none-any.whl
Installing collected packages: attrs
Successfully installed attrs-19.1.0
You are using pip version 19.0.3, however version 19.1.1 is available.
You should consider upgrading via the 'python -m pip install --upgrade pip' command.
Updating requirements.lock.txt ...
$ ls -Name
.venv
requirements.lock.txt
$ cat .\requirements.lock.txt
attrs==19.1.0
```

#### Why?

Because most of the time you want to install packages locally, and only occasionally to install them globally.

#### How it works?

If you are already inside a virtual environment, then `pip-do` runs `pip` inside that environment.

On the other hand, if you are not inside a virtual environment yet, and there exists one that can be activated, then `pip-do` activates that environment before passing work to `pip`.

When there's no environment to activate, then `pip-do`  creates a new one for you in the current directory and activates it, before invoking `pip`.

As a bonus point, `pip-do` automatically creates or updates `requirements.lock.txt` file to contain all installed packages (`pip freeze`).

### `node-activate` - Switching Node.js environments

[`node-activate` (alias to `Set-NodeRuntime`)](Modules/Set-NodeRuntime/Set-NodeRuntime.psm1) activates one of installed Node.js interpreters.

```console
$ node-activate 8
```

To install new Node.js interpreter, use [`nvm-windows`](https://github.com/coreybutler/nvm-windows).

#### Why?

This tool activates particular interpreter only in the current scope (in accordance to [`nvm`](https://github.com/nvm-sh/nvm) behavior)
and not globally (as [`nvm-windows`]((https://github.com/coreybutler/nvm-windows)) does).
