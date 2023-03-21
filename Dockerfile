# syntax=docker/dockerfile:1.4

#====Preparation Stage====
ARG BUILDPLATFORM
FROM --platform=$BUILDPLATFORM python:3.8 AS BUILDER

# cryptography build dependencies
RUN apt-get update
RUN apt-get install -y build-essential libssl-dev libffi-dev python3-dev cargo pkg-config cmake

#====Cryptography Stage====
FROM BUILDER AS CRYPTOGRAPHY
RUN pip3 install --upgrade pip
RUN pip3 install cryptography

#====Driver Stage====
FROM BUILDER AS DRIVER
# install scan-provider-cpp
WORKDIR /app
RUN git clone https://github.com/SLSfEi/scan-provider-cpp.git --recursive
WORKDIR /app/driver_build
RUN cmake /app/scan-provider-cpp
RUN make


#====APP Stage====
FROM CRYPTOGRAPHY AS WEB_APP

EXPOSE 8000

# install web-app
WORKDIR /app
RUN git clone https://github.com/SLSfEi/web-app.git
WORKDIR /app/web-app
RUN pip3 install -r requirements.txt
ENV DEBUG 0
ENV DRIVER_EXECUTABLE /app/driver_build/out/scan_provider

# copy driver executable
COPY --from=DRIVER /app/driver_build/out /app/driver_build/out

# run web-app
WORKDIR /app/web-app/smart_rplidar
ENTRYPOINT ["python3"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]


# keep running for debug purposes
#ENTRYPOINT ["tail", "-f", "/dev/null"]
