FROM alpine:latest

ARG version

ARG terraformVersion=1.5.7
ARG packerVersion=1.11.1
ARG jqVersion=1.7.1
ARG ansibleVersion=7.7.0
ARG gcloudVersion=487.0.0
ARG user=guest

ENV BUILD_VERSION=$version
ENV TF_VERSION=$terraformVersion
ENV PACKER_VERSION=$packerVersion
ENV JQ_VERSION=$jqVersion
ENV ANSIBLE_VERSION=$ansibleVersion
ENV GCLOUD_VERSION=$gcloudVersion

USER root
RUN apk update && apk upgrade
RUN wget  --quiet https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
  && unzip terraform_${TF_VERSION}_linux_amd64.zip \
  && mv terraform /usr/bin/terraform \
  && rm terraform_${TF_VERSION}_linux_amd64.zip \
  && chmod 755 /usr/bin/terraform
RUN wget  --quiet https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
  && unzip packer_${PACKER_VERSION}_linux_amd64.zip \
  && mv packer /usr/bin/packer \
  && rm packer_${PACKER_VERSION}_linux_amd64.zip \
  && chmod 755 /usr/bin/packer
RUN wget --quiet https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64 \
  && mv jq-linux-amd64 /usr/bin/jq \
  && chmod 755 /usr/bin/jq
RUN apk add --no-cache git
RUN apk add --no-cache openssh
RUN apk add --no-cache zip
RUN apk add --no-cache python3 py3-pip py3-dateutil py3-httplib2 py3-jinja2 py3-paramiko py3-setuptools py3-yaml curl
RUN pip3 install --break-system-packages --upgrade pip
RUN pip3 install --break-system-packages boto3==1.26.90 requests
RUN pip3 install --break-system-packages ansible==${ANSIBLE_VERSION}
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz \
  && tar -xf google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz -C /usr/local/ \
  && rm google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz
ENV PATH="${PATH}:/usr/local/google-cloud-sdk/bin"
USER ${user}

