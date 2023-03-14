# syntax=docker/dockerfile:1.4

#====Preparation Stage====
ARG BUILDPLATFORM
FROM --platform=$BUILDPLATFORM python:3.8 AS BUILDER

# cryptographgic build dependencies
RUN apt-get update
RUN apt-get install -y build-essential libssl-dev libffi-dev python3-dev cargo pkg-config cmake

#====APP Stage====
FROM BUILDER AS APP

EXPOSE 8000

# install web-app
WORKDIR /app
RUN git clone https://github.com/SLSfEi/web-app.git
WORKDIR /app/web-app
RUN pip3 install -r requirements.txt
ENV DEBUG 0
ENV DRIVER_EXECUTABLE /app/driver_build/out/scan_provider

# install scan-provider-cpp
WORKDIR /app
RUN git clone https://github.com/SLSfEi/scan-provider-cpp.git --recursive
WORKDIR /app/driver_build
RUN cmake /app/scan-provider-cpp
RUN make

# run web-app
WORKDIR /app/web-app/smart_rplidar
ENTRYPOINT ["python3"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]


# keep running for debug purposes
#ENTRYPOINT ["tail", "-f", "/dev/null"]
