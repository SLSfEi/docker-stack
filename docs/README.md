# Docker Stack
This docker container facilitate the deployment process of SLSfEi System by automatically build and install all dependencies for [SLSfEi/web-app](https://github.com/SLSfEi/web-app) and [SLSfEi/scan-provider-cpp](https://github.com/SLSfEi/scan-provider-cpp)


![system diagram](./SLSfEI.drawio.png)


# Configurations
The configuration file `driver_config.ini` is based on `config.ini` from [SLSfEi/scan-provider-cpp](https://github.com/SLSfEi/scan-provider-cpp)

**Note:** Current configuration is set to build for Raspberry Pi 4. If you want to build for other platform, please change build argument `BUILDPLATFORM` in `docker-compose.yml` accordingly.
