FROM mysql

RUN apt-get update -y && \
    apt-get install vim -y && \
    apt-get install cron -y && \
    apt-get install htop -y && \
    apt-get install logrotate -y && \
    mkdir /backups && \
    touch /backups/all_databases

ENV MYSQL_ROOT_PASSWORD password
