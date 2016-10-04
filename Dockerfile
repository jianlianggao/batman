FROM ubuntu:16.04

MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

# Perform upgrades
# RUN apt-get -y update #This line can be removed

# Install dependencies # the libcurl and libssl may not be necessary to install
# RUN apt-get -y --no-install-recommends install \
# 	libcurl4-openssl-dev \
#	libssl-dev
#RUN apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Install R
#RUN apt-get update && apt-get install -y --no-install-recommends r-base r-base-dev
#RUN apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Install BATMAN dependencies
#RUN R -e "install.packages(c('doSNOW','plotrix','getopt','optparse'), repos='http://cran.us.r-project.org')"
#RUN R -e "install.packages('batman', repos='http://R-Forge.R-project.org')"

# Install R & BATMAN
RUN apt-get update && apt-get install -y --no-install-recommends r-base r-base-dev \
                              libcurl4-openssl-dev libssl-dev git && \
    echo 'options("repos"="http://cran.rstudio.com", download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
    R -e "install.packages(c('doSNOW','plotrix','getopt','optparse'))" && \
    R -e "install.packages('batman', repos='http://R-Forge.R-project.org')" && \
    apt-get purge -y r-base-dev git libcurl4-openssl-dev libssl-dev && \
    apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Add runBATMAN.r to /usr/local/bin
ADD runBATMAN.R /usr/local/bin
RUN chmod 0755 /usr/local/bin/runBATMAN.R

# Define entry point, useful for generale use
ENTRYPOINT ["runBATMAN.R"]
