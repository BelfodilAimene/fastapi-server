# A simple template for pyenv, poetry and docker fast api server

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

```bash
poetry add flask
```

This will output
```bash
Using version ^0.115.8 for fastapi

Updating dependencies
Resolving dependencies... (1.5s)

Package operations: 9 installs, 0 updates, 0 removals

  - Installing idna (3.10)
  - Installing sniffio (1.3.1)
  - Installing typing-extensions (4.12.2)
  - Installing annotated-types (0.7.0)
  - Installing anyio (4.8.0)
  - Installing pydantic-core (2.27.2)
  - Installing pydantic (2.10.6)
  - Installing starlette (0.45.3)
  - Installing fastapi (0.115.8)

Writing lock file
```

It is worth to notice that `pyproject.toml` will be updated by adding in the list of your dependencies `fastapi (>=0.115.8,<0.116.0)` that indicates that your project will be compatible with any version between  `0.115.8` and `<0.116.0`.

Please notice also that a `poetry.lock` will be generated containing the exact version of all the install dependencies. For instance in this project the fastapi version installed is `0.115.8`.

Remember:

1 - `pyproject.toml` holds the list of your `requirements` and may cover many supported versions.

2 - `poetry.lock` holds the exact version installed and used currently by the project.

### Add uvicorn following the previous commands

```
poetry add uvicorn
```

## 3 - Create your fastapi project


### Create main.py with a simple server
Create your `main.py` containing the following lines:

```python
from fastapi import FastAPI
import uvicorn

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/products/{name}")
def show_products(name: str):
    return {"name": name}

if __name__ == "__main__":
    uvicorn.run("main:app", 
                host="0.0.0.0", 
                port=8000, 
                reload=False, 
                log_level="debug")
```

### Run your project

Run always using poetry
```bash
poetry run python3 main.py
```

This will run your fastapi server a `REST API server`.


## 4 - Dockerize your project

### Install docker
Install docker using https://docs.docker.com/engine/install/ubuntu/

### Configure docker group to avoid always using sudo
Follow https://docs.docker.com/engine/install/linux-postinstall/

### Create your docker image
Create Dockerfile [Dockerfile](Dockerfile).

You may notice that we are using here two-stage building where the first `FROM` introduce the builder image that use poetry to generate the list of your requirements. The second `FROM` produce the final image which is lighter since it does not contain poetry.

This technique is called `multi-stage builds` (See https://docs.docker.com/get-started/docker-concepts/building-images/multi-stage-builds/ for more details) and is a best practice in Docker when buidling images. 

Remember, the smaller the image the better is.

### Build your image
```bash
docker build . -t cute-server:1.0.0-alpha
```

### Add a simple docker compose
Create a docker compose file [`docker-compose.yaml`](./docker-compose.yaml) that run your image and expose its port to 8000.

### Run your docker compose
```bash
docker compose up
```

### Enjoy your server using its doc
Go to [localhost:8000/docs](http://localhost:8000/docs).