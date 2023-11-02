ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}


ENV PIP_ROOT_USER_ACTION=ignore

ARG USER_LOGIN

ENV USER_LOGIN=${USER_LOGIN}

RUN echo ${PYTHON_VERSION}
RUN apt-get update \
    && apt-get install -y htop \
    make \
    git

RUN python -m pip install Flask

WORKDIR /backster/app

COPY . /backster/app/

CMD ["python", "./main.py"]
