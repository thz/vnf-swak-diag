FROM golang:1.9 as buildstage

ENV GOPATH /go
WORKDIR /go
RUN go get -u github.com/golang/dep/cmd/dep
RUN go get -d github.com/osrg/gobgp/gobgp
RUN go get -d github.com/osrg/gobgp/gobgpd
RUN cd /go/src/github.com/osrg/gobgp && dep ensure
RUN go get github.com/osrg/gobgp/gobgp
RUN go get github.com/osrg/gobgp/gobgpd

FROM ubuntu:18.04 as runstage

COPY --from=buildstage /go/bin/gobgp /usr/bin
COPY --from=buildstage /go/bin/gobgpd /usr/bin

RUN apt-get update -y
RUN apt-get install -y \
	apt-transport-https \
	arping \
	curl \
	gnupg \
	htop \
	iftop \
	iperf \
	iperf3 \
	iproute2 \
	iptables \
	iputils-ping \
	jq \
	keepalived \
	ldnsutils \
	mtr \
	net-tools \
	openssh-client \
	python \
	socat \
	strace \
	tcpdump \
	vim

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN printf "deb http://apt.kubernetes.io/ kubernetes-xenial main\n" > /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update -y

RUN apt-get install -y kubectl kubeadm kubelet

CMD [ "bash" ]
