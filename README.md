# A Simple Template for pyenv, Poetry, and Docker FastAPI Server
## 1 - Install pyenv to Manage Various Python Versions
First, install pyenv by following the instructions at: https://github.com/pyenv/pyenv#1-automatic-installer-recommended

### Install a Python Version Using pyenv
To install Python version 3.11.6, run:

```bash
pyenv install 3.11.6
```

### Use Python 3.11.6 in Your Current Project
To use Python 3.11.6 for your project:

```bash
pyenv local 3.11.6
```

This will create a `.python-version` file containing `3.11.6` which pyenv will use to configure the Python version for the current directory. You can verify this by running:

```bash
pyenv which python
```

This should output:

```bash
/home/user/.pyenv/versions/3.11.6/bin/python
```

Note that your system Python version may be different. For example, on my laptop:

```bash
python3 --version
```

outputs:

```bash
Python 3.12.3
```

You can check your system's Python path with the following command:

```bash
which python3
```



This output a different path, like:

```bash
/usr/bin/python3
```

## 2 - Install Poetry as Your Dependency Manager
First, install Poetry by following the instructions at: https://python-poetry.org/docs/#installing-with-the-official-installer

### Initialize Your Project
Run the following command to initialize your project:

```bash
poetry init
```


This command will guide you through creating the `pyproject.toml` configuration.

Example output:

```bash
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

The previous command generate [pyproject.tom](pyproject.tom) that will list the list of your `dependencies`.

### Next tell poetry that you want to use pyenv python 

```bash
poetry env use $(pyenv which python)
```

This will create a virtual environment where all dependencies will be installed in the .venv directory, rather than on the system Python installation.

### Add FastAPI Dependencies
To add FastAPI as a dependency, run:

```bash
poetry add fastapi
```

This will output:

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

Note that `pyproject.toml` will be updated to reflect the new dependency:

```toml
dependencies = [
    {name = "fastapi", version = "^0.115.8"}
]
```

The [`poetry.lock`](poetry.lock) file will also be generated, containing the exact version of all installed dependencies (e.g., fastapi==0.115.8).

Important:

1 - pyproject.toml lists your project’s requirements and may specify version ranges.
2 - poetry.lock contains the exact versions of the dependencies installed in your project.


### Add Uvicorn

To add Uvicorn (the ASGI server for FastAPI), run:

```bash
poetry add uvicorn
```

## 3 - Create Your FastAPI Project
Create `main.py` with a Simple Server
Create a main.py file with the following content:

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

### Run Your Project
To run your project, use Poetry:

``` bash
poetry run python3 main.py
```

This will start your FastAPI server, and you'll have a running REST API server.

## 4 - Dockerize Your Project
### Install Docker
Follow the instructions to install Docker for Ubuntu: https://docs.docker.com/engine/install/ubuntu/

### Configure Docker Group to Avoid Using sudo Every Time
Follow the post-installation steps for Docker: https://docs.docker.com/engine/install/linux-postinstall/

### Create Your Docker Image
Create Dockerfile [Dockerfile](Dockerfile). The Dockerfile will use a multi-stage build: the first stage will install Poetry and generate the list of dependencies, while the second stage will build a smaller image without Poetry.

You can notice also that the Dockerfile does not use `pyenv` as the python version is already fixed using `FROM python:3.11.6-slim-bookworm`. 

### Build Your Docker Image
To build the Docker image, run:

```bash
docker build . -t cute-server:1.0.0-alpha
```

### Add a Simple Docker Compose File
Create a [`docker-compose.yaml`](./docker-compose.yaml) file to define the service and expose port 8000.

Run Your Docker Compose
To start the server with Docker Compose, run:

```bash
docker compose up
```

### Access the Server Documentation
Once the server is running, you can access the API documentation at: http://localhost:8000/docs.