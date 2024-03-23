# Use the latest alpine image as base
FROM alpine:latest

RUN apk add --no-cache \
    openssl \
    perl \
    curl \
    gdbm \
    vim \
    wget \
    make \
    perl-dev \
    build-base \
    git \
    perl-compress-raw-zlib \
    perl-date-manip \
    perl-datetime \
    perl-datetime-format-iso8601 \
    perl-datetime-format-sqlite \
    perl-datetime-format-strptime \
    perl-datetime-timezone \
    perl-dbd-sqlite \
    perl-dbi \
    perl-digest-sha1 \
    perl-file-homedir \
    perl-file-slurp \
    perl-file-which \
    perl-http-message \
    perl-html-tree \
    perl-io-gzip \
    perl-io-stringy \
    perl-libwww \
    perl-lingua-en-numbers-ordinate \
    perl-lingua-preferred \
    perl-list-moreutils \
    perl-lwp-protocol-https \
    perl-lwp-useragent-determined \
    perl-term-progressbar \
    perl-term-readkey \
    perl-test-requiresinternet \
    perl-timedate \
    perl-unicode-string \
    perl-xml-libxml \
    perl-xml-parser \
    perl-xml-treepp \
    perl-xml-twig \
    perl-xml-writer \
    perl-dev \
    perl-cgi \
    perl-data-dump \
    perl-json \
    perl-uri-encode \
    perl-xml-dom \
    apache2 \
    apache2-utils 

# Install cpanm
RUN curl -L https://cpanmin.us | perl - App::cpanminus

# Install HTTP::Cache::Transparent
RUN cpanm HTTP::Cache::Transparent DateTime::Duration

# Copy custom configuration file to serve /home directory
COPY httpd.conf /etc/apache2/httpd.conf

# Copy start script
COPY start_apache.sh /app/start_apache.sh

# Set the working directory
WORKDIR /app

# Clone XMLTV repository
RUN git clone https://github.com/XMLTV/xmltv.git

# Change to the XMLTV source directory
WORKDIR /app/xmltv

# Build and install XMLTV
RUN perl Makefile.PL -y && make && make test && make install

RUN chmod +x /app/start_apache.sh

# Expose port 80
EXPOSE 80

# Create User www-data
RUN adduser -D -u 1000 -G www-data www-data

RUN mkdir /home/web-ui

# Define a default variable for the script command.
ENV tv_grab_command=tv_grab_pt_vodafone
ENV days=1

# Set the entry point to the start script
CMD ["/bin/sh", "/app/start_apache.sh"]
