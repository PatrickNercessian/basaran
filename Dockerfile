FROM nvcr.io/nvidia/pytorch:22.12-py3

# Create app directory
WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y nginx

# Install app dependencies
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Bundle app source
COPY . .

# Expose ports
EXPOSE 80

# Force the stdout and stderr streams to be unbuffered
ENV PYTHONUNBUFFERED="1"

# Hide welcome message from bitsandbytes
ENV BITSANDBYTES_NOWELCOME="1"

# Provide default environment variables
# ENV MODEL="bigscience/bloom-560m"
ENV MODEL="facebook/opt-125m"
ENV HOST="0.0.0.0"
ENV NGINX_PORT="80"
ENV WAITRESS_PORT="7999"
ENV MODEL_REVISION=""
ENV MODEL_CACHE_DIR="/models"
ENV MODEL_LOAD_IN_8BIT="false"
ENV MODEL_LOAD_IN_4BIT="false"
ENV MODEL_LOCAL_FILES_ONLY="false"
ENV MODEL_TRUST_REMOTE_CODE="false"
ENV MODEL_HALF_PRECISION="false"
ENV SERVER_THREADS="32"
ENV SERVER_IDENTITY="basaran"
ENV SERVER_CONNECTION_LIMIT="1024"
ENV SERVER_CHANNEL_TIMEOUT="300"
ENV SERVER_MODEL_NAME=""
ENV SERVER_NO_PLAYGROUND="false"
ENV SERVER_CORS_ORIGINS="*"
ENV COMPLETION_MAX_PROMPT="32768"
ENV COMPLETION_MAX_TOKENS="8192"
ENV COMPLETION_MAX_N="5"
ENV COMPLETION_MAX_LOGPROBS="5"
ENV COMPLETION_MAX_INTERVAL="50"
ENV CUDA_MEMORY_FRACTION="1.0"

# Specify entrypoint and default parameters
ENTRYPOINT [ "python", "-m", "basaran" ]
# ENTRYPOINT [ "python", "basaran/testing_docker.py"]
