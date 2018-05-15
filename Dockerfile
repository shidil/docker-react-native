FROM openjdk:8

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

LABEL MAINTAINER="Shidil Eringa <shidil@live.com>"

# Variables
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_BUILD_TOOLS_VERSION_26="build-tools;26.0.1 build-tools;26.0.2" \
    ANDROID_BUILD_TOOLS_VERSION_25="build-tools;25.0.2 build-tools;25.0.3" \
    ANDROID_BUILD_TOOLS_VERSION_23="build-tools;23.0.1" \
    ANDROID_APIS="platforms;android-23 platforms;android-24 platforms;android-25 platforms;android-26 platforms;android-27" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android" \
    NODEJS_HOME="/nodejs" \
    NODEJS_VERSION=8.11.1 \
    BABEL_DISABLE_CACHE=1

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$GRADLE_HOME/bin:$NODEJS_HOME/bin

WORKDIR /opt

# Gradle setup
RUN dpkg --add-architecture i386 && \
    apt-get -qq update && \
apt-get -qq install -y wget curl gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386


# Android SDK setup
RUN mkdir /root/.android && touch /root/.android/repositories.cfg
RUN mkdir android && cd android && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip && \
    echo y | ./tools/bin/sdkmanager "extras;android;m2repository" && \
    echo y | ./tools/bin/sdkmanager platform-tools && \
    echo y | ./tools/bin/sdkmanager ${ANDROID_APIS} && \
    echo y | ./tools/bin/sdkmanager ${ANDROID_BUILD_TOOLS_VERSION_26} && \
    echo y | ./tools/bin/sdkmanager ${ANDROID_BUILD_TOOLS_VERSION_25} && \
    echo y | ./tools/bin/sdkmanager ${ANDROID_BUILD_TOOLS_VERSION_23} && \
    chmod a+x -R $ANDROID_HOME && \
chown -R root:root $ANDROID_HOME
