FROM ghcr.io/devopsplayground/base-container:latest

ARG ARCHITECTURE=amd64 
ARG PRODUCT=terraform
ARG VERSION=1.9.4
ARG HUGO_VERSION = "0.125.4"

# Install Terraform
RUN cd /tmp && \
    wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_linux_${ARCHITECTURE}.zip && \
    wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig && \
    wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
    gpg --verify ${PRODUCT}_${VERSION}_SHA256SUMS.sig ${PRODUCT}_${VERSION}_SHA256SUMS && \
    grep ${PRODUCT}_${VERSION}_linux_${ARCHITECTURE}.zip ${PRODUCT}_${VERSION}_SHA256SUMS | sha256sum -c && \
    unzip /tmp/${PRODUCT}_${VERSION}_linux_${ARCHITECTURE}.zip -d /tmp && \
    mv /tmp/${PRODUCT} /usr/local/bin/${PRODUCT} && \
    rm -f /tmp/${PRODUCT}_${VERSION}_linux_${ARCHITECTURE}.zip ${PRODUCT}_${VERSION}_SHA256SUMS ${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig 

# Install AWS CLI
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install

# Install Hugo
RUN cd /tmp && \
    curl -L -o hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-${ARCHITECTURE}.tar.gz && \
    tar -zxvf hugo.tar.gz hugo && \
    mv hugo /usr/local/bin/hugo && \
    rm -f hugo.tar.gz

# Clone Playground repo
RUN cd ~ && \
    git clone https://github.com/DevOpsPlayground/tf-test-playground

# Verify installations
RUN terraform --version
RUN aws --version
RUN hugo version
