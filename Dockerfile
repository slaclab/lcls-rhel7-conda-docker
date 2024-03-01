
FROM centos:centos7

RUN yum -y install curl wget bzip2 git gcc mesa-libGL.x86_64 \
    && yum clean all \
    && curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh \
    && bash Mambaforge-$(uname)-$(uname -m).sh -b \
    && rm Mambaforge-$(uname)-$(uname -m).sh \
    && ./root/mambaforge/bin/mamba init \
    && source ~/.bashrc \
    && mamba install -y -c conda-forge conda-pack \
    && mamba clean --all -f -y

COPY run-pack-and-test.sh /run-pack-and-test.sh

RUN chmod +x /run-pack-and-test.sh 

ENTRYPOINT ["/run-pack-and-test.sh"]
