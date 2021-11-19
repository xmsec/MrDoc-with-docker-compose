FROM ubuntu:20.04

LABEL maintainer="xmsec"
ENV PYTHONUNBUFFERED=0 \
    TZ=Asia/Shanghai \
    LISTEN_PORT=10086\
    USER=admin
COPY . /app/MrDoc/

WORKDIR /app/MrDoc

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN apt install python3 python3-pip pwgen netcat -yq
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple uwsgi
RUN apt-get install libmysqlclient-dev -yq &&  pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple mysqlclient
# RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak 
# RUN  set -x \
#     && apk add --no-cache --virtual .build-deps build-base g++ gcc libxslt-dev python2-dev linux-headers \
#     && apk add --no-cache pwgen git tzdata zlib-dev freetype-dev jpeg-dev  mariadb-dev postgresql-dev \
#     && python -m pip install --upgrade pip \
#     && pip --no-cache-dir install -r requirements.txt \
#     && pip --no-cache-dir install mysqlclient \
#     && chmod +x docker_mrdoc.sh \
#     && apk del .build-deps \
#     && rm -rf /var/cache/apk/* 

RUN chmod +x ./start.sh
ENTRYPOINT ["./start.sh"]
# ENTRYPOINT ["/bin/bash"]
