FROM ubuntu:18.04

# aliyun sources
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted" > /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted" >> /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ bionic universe" >> /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates universe" >> /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ bionic multiverse" >> /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates multiverse" >> /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted" >> /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security universe" >> /etc/apt/sources.list && \
  echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security multiverse" >> /etc/apt/sources.list

# We need to install the software properties common before doing add-apt-repository, otherwise it will give an error: add-apt-repository: not found
RUN apt-get update && apt-get install -y \
  software-properties-common \
  git

RUN add-apt-repository ppa:alex-p/tesseract-ocr && apt-get update

# Get tesseract-ocr packages
RUN apt-get install -y \
  libleptonica-dev \
  libtesseract4 \
  libtesseract-dev \
  tesseract-ocr

# Get training packages
RUN apt-get install -y \
  libicu-dev \
  libpango1.0-dev \
  libcairo2-dev

# Get language data.
RUN apt-get install -y \
  tesseract-ocr-ara \
  tesseract-ocr-bel \
  tesseract-ocr-ben \
  tesseract-ocr-bul \
  tesseract-ocr-ces \
  tesseract-ocr-dan \
  tesseract-ocr-deu \
  tesseract-ocr-ell \
  tesseract-ocr-fin \
  tesseract-ocr-fra \
  tesseract-ocr-heb \
  tesseract-ocr-hin \
  tesseract-ocr-ind \
  tesseract-ocr-isl \
  tesseract-ocr-ita \
  tesseract-ocr-jpn \
  tesseract-ocr-kor \
  tesseract-ocr-nld \
  tesseract-ocr-nor \
  tesseract-ocr-pol \
  tesseract-ocr-por \
  tesseract-ocr-ron \
  tesseract-ocr-rus \
  tesseract-ocr-spa \
  tesseract-ocr-swe \
  tesseract-ocr-tha \
  tesseract-ocr-tur \
  tesseract-ocr-ukr \
  tesseract-ocr-vie \
  tesseract-ocr-chi-sim \
  tesseract-ocr-chi-tra \
  tesseract-ocr-eng

RUN apt-get install -y \
  vim \
  wget \
  fonts-dejavu
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
  apt-get install -y ttf-mscorefonts-installer && \
  fc-cache -vf

RUN mkdir -p ~/tesstutorial && cd ~/tesstutorial && \
  git clone --depth 1 https://github.com/tesseract-ocr/tesseract.git && \
  git clone --depth 1 https://github.com/tesseract-ocr/langdata.git && \
  cd tesseract/tessdata && \
  git clone --depth 1 https://github.com/tesseract-ocr/tessdata_best.git && \
  mv tessdata_best best

RUN cd ~/tesstutorial/tesseract/tessdata && \
  wget https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata && \
  wget https://github.com/tesseract-ocr/tessdata/raw/master/osd.traineddata

WORKDIR /root/tesstutorial/tesseract/