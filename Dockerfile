
FROM centos:centos7

RUN curl https://www.getpagespeed.com/files/centos6-eol.repo --output /etc/yum.repos.d/CentOS-Base.repo \ 
    && yum -y install curl wget bzip2 git gcc mesa-libGL.x86_64
RUN curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh \
    && bash Mambaforge-$(uname)-$(uname -m).sh -b \
    && ./root/mambaforge/bin/mamba init \
    && source ~/.bashrc \
    && mamba install -y -c conda-forge conda-pack

COPY run-pack-and-test.sh /run-pack-and-test.sh

RUN chmod +x /run-pack-and-test.sh 

ENTRYPOINT ["/run-pack-and-test.sh"]