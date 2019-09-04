FROM ubuntu:18.04

COPY ["source.list", "opencv-3.4.6.zip", "./"]

ENV DEBIAN_FRONTEND=noninteractive \
  OPENCV4NODEJS_DISABLE_AUTOBUILD=1 \
  CV_VERSION=3.4.6 \
  NODE_VERSION=10.16.3 \
  OPENCV4NODEJS_AUTOBUILD_FLAGS=-DBUILD_LIST=features2d

RUN cat /source.list > /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y build-essential \
  && apt-get install -y --no-install-recommends curl unzip python ca-certificates cmake \
  && mkdir opencv \
  && cd opencv \
  && mv /opencv-${CV_VERSION}.zip . \
  && unzip opencv-${CV_VERSION}.zip \
  && mkdir opencv-${CV_VERSION}/build \
  && cd opencv-${CV_VERSION}/build \
  && cmake_flags="-D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D BUILD_EXAMPLES=OFF \
  -D BUILD_DOCS=OFF \
  -D BUILD_TESTS=OFF \
  -D BUILD_PERF_TESTS=OFF \
  -D WITH_IPP=OFF \
  $OPENCV4NODEJS_AUTOBUILD_FLAGS" \
  && cmake $cmake_flags .. \
  && make -j8 \
  && make install \
  && sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' \
  && ldconfig \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && node -v && npm -v \
  && npm install -g opencv4nodejs --unsafe-perm \
  && rm -rf "/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && rm -rf /opencv \
  && rm -rf /var/lib/apt/lists/* \ 
  && apt-get purge -y build-essential curl unzip ca-certificates cmake \
  && apt-get autoremove -y --purge
