FROM debian:11

ENV DEBIAN_FRONTEND=noninteractive
ENV SPRING_VERSION=105.0

RUN \
    apt-get update && \
    apt-get install -y \
        wget \
        perl \
        libffi-platypus-perl \
        libio-socket-ssl-perl \
        libdbd-sqlite3-perl \
        swig \
        g++ \
        p7zip-full \
    && \
    useradd -md /spads spads

USER spads

RUN \
    cd && \
    wget http://planetspads.free.fr/spads/installer/spadsInstaller.tar && \
    tar xf spadsInstaller.tar && \
    mkdir spring && \
    cd spring && \
    wget "https://master.dl.sourceforge.net/project/springrts/springrts/spring-${SPRING_VERSION}/spring_${SPRING_VERSION}_minimal-portable-linux64-static.7z" && \
    7z x "spring_${SPRING_VERSION}_minimal-portable-linux64-static.7z" && \
    cd .. && \
    echo 'unitsyncPath: /spads/spring\nspringBinariesType: custom\nlobbyLogin: LobbyAccount\nlobbyPassword: LobbyPassword\nowner: LobbyOwner\n' > spadsInstaller.auto && \
    echo "Installing with custom auto data:" && \
    cat spadsInstaller.auto && \
    perl spadsInstaller.pl && \
    cd spring && \
    ./pr-downloader --download-game ba:stable

WORKDIR /spads
CMD ["perl", "spads.pl", "etc/spads.conf"]
