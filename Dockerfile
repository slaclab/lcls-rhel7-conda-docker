FROM centos:centos7

# Fix broken mirrorlist (use vault.centos.org instead)
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo \
 && sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo

RUN yum -y install curl wget bzip2 git gcc mesa-libGL.x86_64 \
    && yum clean all \
    && curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh \
    && bash Miniforge3-$(uname)-$(uname -m).sh -b -p /opt/miniforge \
    && rm Miniforge3-$(uname)-$(uname -m).sh \
    && /opt/miniforge/bin/mamba install -y -c conda-forge conda-pack \
    && /opt/miniforge/bin/mamba clean --all -f -y \
    && git config --system core.logallrefupdates false

ENV PATH="/opt/miniforge/bin:$PATH"

COPY run-pack-and-test.sh /run-pack-and-test.sh

RUN chmod +x /run-pack-and-test.sh 

ENTRYPOINT ["/run-pack-and-test.sh"]
