# REF: https://learn.microsoft.com/ja-jp/dotnet/core/docker/build-container?tabs=windows
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
RUN apt update -y

# 日本語設定
RUN apt-get update && apt-get install -y locales &&\
    sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen &&\
    locale-gen
ENV LANG ja_JP.UTF-8

# OmniSharp
RUN mkdir /usr/local/bin/omnisharp &&\
    cd /usr/local/bin/omnisharp &&\
    curl -L https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v1.39.10/omnisharp-linux-x64-net6.0.tar.gz | tar xz
ENV PATH="${PATH}:/usr/local/bin/omnisharp"

WORKDIR /app

# emacs
RUN grep '^deb ' /etc/apt/sources.list | sed 's/^deb/deb-src/g' > /etc/apt/sources.list.d/deb-src.list &&\
    apt update -y &&\
    apt install -y curl &&\
    apt install -y build-essential &&\
    apt build-dep -y emacs &&\
    apt install -y libjansson-dev
RUN curl -LO https://ftp.gnu.org/gnu/emacs/emacs-29.1.tar.gz &&\
    tar xf emacs-29.1.tar.gz &&\
    cd emacs-29.1 &&\
    ./autogen.sh &&\
    ./configure --without-x &&\
    make &&\
    make install &&\
    rm -rf /emacs-29.1.tar.gz &&\
    rm -rf /emacs-29.1
