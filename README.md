# R Docker Images

## Description

CRAN tests packages on a number of different platforms. This repository contains
the Dockerfiles to create the images that are similar to the ones used by CRAN:

| R version | OS           | Compiler | Notes |
|-----------|--------------|----------|-------|
| 4.4.2     | Debian 12    | Clang 20 |       |
| 4.4.2     | Debian 12    | GCC 11   |       |
| 4.4.2     | Fedora 40    | Clang 20 |       |
| 4.4.2     | Fedora 40    | GCC 11   |       |

## Using the images

[Here]() is an example of how to use the images with GitHub Actions:

## Publish the images

Note for myself: I have to login to the docker hub before I can push the images.

```
docker login
docker build -t pachadotdev/fedora-clang:latest .
docker push pachadotdev/fedora-clang:latest
```
