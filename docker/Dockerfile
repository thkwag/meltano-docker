ARG MELTANO_PYTHON_VERSION=3.9
FROM python:${MELTANO_PYTHON_VERSION}

ARG MELTANO_VERSION=2.19.1
ARG MELTANO_PROJECT_DIRECTORY="/meltano/project"
ARG MELTANO_PROJECT_READONLY=1

ENV PIP_NO_CACHE_DIR=1
ENV MELTANO_PROJECT_READONLY=${MELTANO_PROJECT_READONLY}

RUN mkdir -p "${MELTANO_PROJECT_DIRECTORY}" && \
    apt-get update && \
    apt-get install -y build-essential freetds-bin freetds-dev git libkrb5-dev \
        libssl-dev tdsodbc unixodbc unixodbc-dev \
        default-mysql-client default-libmysqlclient-dev && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

WORKDIR "${MELTANO_PROJECT_DIRECTORY}"

RUN python -m venv /venv
ENV PATH="/venv/bin:${PATH}"

RUN pip install --upgrade pip wheel && \
    pip install "meltano[azure,gcs,mssql,s3]==${MELTANO_VERSION}"

COPY ./docker/requirements.txt .
RUN pip install -r requirements.txt

COPY ./docker/project .
RUN if [ ! -e ./meltano.yml ]; then meltano init . --force; fi
RUN meltano install


#ENTRYPOINT ["meltano"]
CMD ["tail", "-f", "/dev/null"]