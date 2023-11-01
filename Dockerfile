FROM python:3.10.13


ENV PIP_ROOT_USER_ACTION=ignore

ARG user_login

ENV USER_LOGIN=${user_login}

RUN apt-get update \
    && apt-get install -y htop \
    make \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install Flask

WORKDIR /backster/app

COPY . /backster/app/

CMD ["python", "./main.py"]
