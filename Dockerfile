FROM python:3.7-alpine3.9

ENV OJ_ENV production

ADD . /app
WORKDIR /app

HEALTHCHECK --interval=5s --retries=3 CMD python2 /app/deploy/health_check.py



#RUN cat /etc/apt/sources.list
#
#RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
#    echo "deb http://mirrors.aliyun.com/debian jessie main contrib non-free" > /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/debian jessie main contrib non-free" >> /etc/apt/sources.list  && \
#    echo "deb http://mirrors.aliyun.com/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/debian-security jessie/updates main contrib non-free" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/debian-security jessie/updates main contrib non-free" >> /etc/apt/sources.list



RUN mkdir ~/.pip && \
    touch ~/.pip/pip.conf

RUN echo "[global]" > ~/.pip/pip.conf && \
    echo "index-url = https://pypi.tuna.tsinghua.edu.cn/simple" >> ~/.pip/pip.conf && \
    echo "[install]" >> ~/.pip/pip.conf && \
    echo "trusted-host=mirrors.aliyun.com" >> ~/.pip/pip.conf


RUN apk add --update --no-cache build-base nginx openssl curl unzip supervisor jpeg-dev zlib-dev postgresql-dev freetype-dev && \
    pip install --no-cache-dir -r /app/deploy/requirements.txt && \
    apk del build-base --purge

RUN curl -L  $(curl -s  https://api.github.com/repos/QingdaoU/OnlineJudgeFE/releases/latest | grep /dist.zip | cut -d '"' -f 4) -o dist.zip && \
    unzip dist.zip && \
    rm dist.zip

ENTRYPOINT /app/deploy/entrypoint.sh
