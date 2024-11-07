ARG PYTORCH_VERSION=2.1.2
ARG CUDA_VERSION=11.8
ARG CUDNN_VERSION=8
ARG HDBET_COMMIT=ae16068
ARG RADIFOX_VERSION=1.0.3

FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-runtime
LABEL maintainer=blake.dewey@jhu.edu
ARG PYTORCH_VERSION
ARG CUDA_VERSION
ARG CUDNN_VERSION
ARG HDBET_COMMIT
ARG RADIFOX_VERSION

ENV PYTHONUSERBASE=/opt/python

RUN echo -e "{\n \
    \"PYTORCH_VERSION\": \"${PYTORCH_VERSION}\"\n \
    \"CUDA_VERSION\": \"${CUDA_VERSION}\"\n \
    \"CUDNN_VERSION\": \"${CUDNN_VERSION}\"\n \
    \"HDBET_COMMIT\": \"${HDBET_COMMIT}\"\n \
    \"RADIFOX_VERSION\": \"${RADIFOX_VERSION}\"\n \
}" > /opt/manifest.json

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates git && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
        radifox==${RADIFOX_VERSION} \
        git+https://github.com/MIC-DKFZ/HD-BET.git@${HDBET_COMMIT}

COPY setup_hdbet.py /opt
RUN python /opt/setup_hdbet.py && \
    rm -f /opt/setup_hdbet.py

ENV PATH /opt/run:${PATH}
COPY --chmod=755 run-hdbet /opt/run/
ENTRYPOINT ["run-hdbet"]
