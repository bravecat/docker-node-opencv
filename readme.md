# docker-node-opencv

生成 docker image, 包含 opencv, nodejs 和 opencv4nodejs. 镜像大小约 311m.

## 配置

- Base image: `FROM ubuntu:18.04`
- ubuntu 源: `source.list`
- opencv 版本: `CV_VERSION=3.4.6`
- opencv 编译模块列表: `OPENCV4NODEJS_AUTOBUILD_FLAGS=-DBUILD_LIST=features2d`
- nodejs 版本: `NODE_VERSION=10.16.3`
