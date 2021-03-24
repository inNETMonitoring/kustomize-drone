FROM alpine:3
RUN apk add --no-cache curl ca-certificates bash tar

RUN curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
chmod +x /usr/local/bin/kubectl
RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.0.5/kustomize_v4.0.5_linux_amd64.tar.gz | tar -xzC /usr/local/bin && \
chmod +x /usr/local/bin/kustomize

COPY update.sh /bin/
RUN chmod +x /bin/update.sh
ENTRYPOINT ["/bin/update.sh"]
