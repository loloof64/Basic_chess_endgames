# Building for Linux
# Image with Flutter and AppImage Builder set.
# Don't forget to mount current project's folder when running.

# Setup Ubuntu
FROM appimagecrafters/appimage-builder:latest
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update -y
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install --yes bash curl wget file git unzip xz-utils zip libglu1-mesa build-essential libgtk-3-dev libtool autoconf libssl-dev sudo gcc-13 g++-13
RUN sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 10
RUN sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 10

# Setup user
RUN useradd -m developer && echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "Defaults:developer !requiretty" >> /etc/sudoers
USER developer
WORKDIR /home/developer

# Setup CMake
ARG CMAKE_VERSION=3.30
ARG CMAKE_BUILD=2
RUN mkdir -p /home/developer/temp
WORKDIR /home/developer/temp
RUN wget "https://cmake.org/files/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.$CMAKE_BUILD.tar.gz"
RUN tar -xzvf "cmake-$CMAKE_VERSION.$CMAKE_BUILD.tar.gz"
WORKDIR "/home/developer/temp/cmake-$CMAKE_VERSION.$CMAKE_BUILD/"
RUN ./bootstrap
RUN make -j$(nproc)
RUN sudo make install
WORKDIR /home/developer

# Setup Ninja
ARG NINJA_VERSION=1.12.1
WORKDIR /home/developer/temp
RUN wget "https://github.com/ninja-build/ninja/releases/download/v$NINJA_VERSION/ninja-linux.zip"
RUN unzip ninja-linux.zip -d ninja
RUN chmod +x ./ninja/ninja
RUN sudo mv ./ninja/ninja /usr/local/bin/
WORKDIR /home/developer

# Setup Clang
ARG CLANG_VERSION=18
WORKDIR /home/developer/temp
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN sudo ./llvm.sh $CLANG_VERSION
WORKDIR /home/developer
RUN sudo ln -s /usr/bin/clang-18 /usr/bin/clang
RUN sudo ln -s /usr/bin/clang++-18 /usr/bin/clang++

# Setup Flutter
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.8-stable.tar.xz
RUN tar xf flutter_linux_3.13.8-stable.tar.xz
RUN rm -rf flutter_linux_3.13.8-stable.tar.xz
ENV PATH=$PATH:/home/developer/flutter/bin
RUN flutter upgrade