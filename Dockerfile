FROM alpine:3.14

LABEL maintainer="arthaprihardana"

ENV ANDROID_SDK_TOOLS_VERSION=7583922
ENV ANDROID_HOME='/opt/android-sdk-linux'
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools:$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/platform-tools

RUN apk update \
    && apk add openjdk8 \
    && apk add unzip \
    && apk add curl

# Download android sdk tools
RUN curl -o commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip \
    && unzip commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip -d ${ANDROID_HOME} \
    && rm -v commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip

WORKDIR /usr/src/app

# Install packages
ADD packages.txt .
RUN $ANDROID_HOME/cmdline-tools/bin/sdkmanager --update --sdk_root=${ANDROID_SDK_ROOT} \
    && while read -r pkg; do PKGS="${PKGS}${pkg} "; done < packages.txt \
    && $ANDROID_HOME/cmdline-tools/bin/sdkmanager $PKGS > /dev/null --sdk_root=${ANDROID_SDK_ROOT} \
    && rm packages.txt