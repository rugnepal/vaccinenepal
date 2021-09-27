FROM rocker/r-ver:4.1.0
 
# MAINTAINER Binod Jung Bogati <binod.bogati@numericmind.com>
 
RUN apt-get clean all && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    libhdf5-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libpng-dev \
    libxt-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libglpk40 \
    libgit2-28 \
    default-jre \
    default-jdk && \
    R CMD javareconf && \
    apt-get clean all && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

mkdir /home/twitter_bot && chmod 755 /home/twitter_bot && \

R -e "options(Ncpus = 2, repos='https://packagemanager.rstudio.com/all/__linux__/focal/3018940'); if(!require(pacman)) {install.packages('pacman')}; pacman::p_load(here, rJava, rtweet, dplyr, tidyr, stringr, googledrive, tabulizer);"

COPY . /home/twitter_bot/

WORKDIR /home/twitter_bot/

#RUN Rscript "twitter.R"
