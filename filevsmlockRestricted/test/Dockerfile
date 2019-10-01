FROM php:7.2-cli-stretch
RUN apt-get update
RUN apt-get -y install netcat
RUN docker-php-ext-install sysvsem
RUN docker-php-ext-install sockets
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install mysqli
RUN apt-get update && apt-get -y install git mysql-client vim
RUN cd / && git clone https://github.com/Ivinco/stress-tester app
WORKDIR /app
COPY generate_queries.php .
COPY hn_top.txt .
COPY test.sh .
#CMD ["sleep", "10000"]
CMD [ "bash", "./test.sh" ]
