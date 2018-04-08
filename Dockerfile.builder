# base Command Central server image
FROM store/softwareag/commandcentral:10.1.0.1-builder

# build args
ARG REPO_USR
ARG REPO_PWD
ARG CC_BASE_ENV

ENV SAG_HOME=/opt/softwareag
ENV CC_BASE_ENV=$CC_BASE_ENV
ENV REPO_USR=$REPO_USR
ENV REPO_PWD=$REPO_PWD

ADD . /src
WORKDIR /src

# start tooling, apply template(s), cleanup
RUN sagccant setup stopcc -Dbuild.dir=/tmp && \
    cd $SAG_HOME && rm -fr /tmp/* common/conf/nodeId.txt profiles/SPM/logs/* profiles/CCE/logs/* && \
    rm -fr /src/*

ONBUILD ADD . /src
ONBUILD RUN $SAG_HOME/profiles/SPM/bin/provision.sh

# Set path to the main executable folder
ENV PATH=$PATH:$SAG_HOME

ENTRYPOINT ["cce-entrypoint.sh"]