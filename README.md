# Configure your environment

## 1 - Install pyenv to manage various python versions:
First install pyenv following
https://github.com/pyenv/pyenv?tab=readme-ov-file#1-automatic-installer-recommended

### Install python version using pyenv

Install python version 3.11.6.
```bash
pyenv install 3.11.6
```

### Use python 3.11.6 in your current project
Use python 3.11.6 for your project
```bash
pyenv local 3.11.6
```

This will create file `.python-version` containing `3.11.6` that `pyenv` will use to configure the version of python to use in the current directory. You can notice that the following command:
```bash
pyenv which python
```

will output
```bash
/home/user/.pyenv/versions/3.11.6/bin/python
```

whilst my system python version may be different for instance, in my: laptop
```bash
python3 --version
```
outputs
```bash
Python 3.12.3
```

You may check your system python version using command `which`: 
```bash
which python3
```

outputs for me a different path
```bash
/usr/bin/python3
```

## 2 - Install poetry as your dependency manager:
First install poetry following
https://python-poetry.org/docs/#installing-with-the-official-installer

### First initialize your project
Run `poetry init`

```bash
This command will guide you through creating your pyproject.toml config.

Package name [fastapi-template-project]:       
Version [0.1.0]:  
Description []:  
Author [aimene belfodil <aimene.belfodil@munic.io>, n to skip]:  
License []:  
Compatible Python versions [>=3.12]:  >=3.11

Would you like to define your main dependencies interactively? (yes/no) [yes] no
Would you like to define your development dependencies interactively? (yes/no) [yes] no
Generated file

[project]
name = "fastapi-template-project"
version = "0.1.0"
description = ""
authors = [
    {name = "aimene belfodil",email = "aimene.belfodil@munic.io"}
]
readme = "README.md"
requires-python = ">=3.11"
dependencies = [
]


[build-system]
requires = ["poetry-core>=2.0.0,<3.0.0"]
build-backend = "poetry.core.masonry.api"


Do you confirm generation? (yes/no) [yes] yes
```

The previous command generate `pyproject.tom` that will list the list of your `dependencies`.


### Next tell poetry that you want to use pyenv as 

```bash
poetry env use $(pyenv which python)
```

This command will create `virtualenv` where all dependencies will no longer be installed in your system but only in the directory `.venv`.

### Next add fastapi dependencies


