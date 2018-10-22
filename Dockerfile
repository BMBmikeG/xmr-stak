# Latest version of ubuntu
FROM nvidia/cuda:9.0-base

# Default git repository
ENV GIT_REPOSITORY https://github.com/BMBmikeG/xmr-stak.git
ENV XMRSTAK_CMAKE_FLAGS -DXMR-STAK_COMPILE=generic -DCUDA_ENABLE=ON -DOpenCL_ENABLE=OFF

# Innstall packages
RUN apt-get update \
    && set -x \
    && apt-get install -qq --no-install-recommends -y build-essential ca-certificates cmake cuda-core-9-0 git cuda-cudart-dev-9-0 libhwloc-dev libmicrohttpd-dev libssl-dev \
    && git clone $GIT_REPOSITORY \
    && cd /xmr-stak \
    && cmake ${XMRSTAK_CMAKE_FLAGS} . \
    && make \
    && cd - \
    && mv /xmr-stak/bin/* /usr/local/bin/ \
    && rm -rf /xmr-stak \
    && apt-get purge -y -qq build-essential cmake cuda-core-9-0 git cuda-cudart-dev-9-0 libhwloc-dev libmicrohttpd-dev libssl-dev \
    && apt-get clean -qq
    	
VOLUME /mnt

WORKDIR /mnt

ENTRYPOINT ["/usr/local/bin/xmr-stak"]
CMD ["-o", "stratum+tcp://pool.supportxmr.com:3333","-u","89vaXuYfqgvVrpYoduwrZBUie6N2dcjMgN5Ai4qrmTB6GXSGKYfjocvMBSB2ttX2M47f6YmQSXnHYd5nMe3F3J7P2P7VLzo","-p","docker","-i","4445","--currency","monero7","--rigid","docker"]
