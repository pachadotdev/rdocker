# Use Debian 12 as the base image
FROM debian:12

# Install OpenSSH server and other necessary packages
RUN apt-get update && \
    apt-get install -y openssh-server passwd sudo && \
    apt-get clean

# Enable SSH service
RUN systemctl enable ssh

# Install GCC
RUN apt-get update && \
    apt-get install -y gcc g++ && \
    apt-get clean

# Install R dependencies
RUN apt-get update && \
    apt-get install -y wget which r-base r-base-dev libreadline-dev libx11-dev libxt-dev libc++-dev libc++abi-dev libharfbuzz-dev libfribidi-dev libssl-dev libcurl4-openssl-dev && \
    apt-get clean

# Set environment variables for GCC
ENV CC=gcc
ENV CXX=g++

# Download and extract R source
RUN wget https://cran.r-project.org/src/base/R-4/R-4.4.2.tar.gz -O R-4.4.2.tar.gz && \
    tar -xzvf R-4.4.2.tar.gz && \
    cd R-4.4.2 && \
    echo 'CC="gcc"' > config.site && \
    echo 'CXX="g++"' >> config.site && \
    echo 'CFLAGS="-g -O3 -Wall -pedantic"' >> config.site && \
    echo 'FFLAGS="-g -O2 -mtune=native"' >> config.site && \
    echo 'CXXFLAGS="-g -O3 -Wall -pedantic"' >> config.site && \
    echo 'MAIN_LD="g++"' >> config.site && \
    echo 'export RGL_USE_NULL="true"' >> config.site && \
    echo 'export R_DONT_USE_TK="true"' >> config.site && \
    ./configure --prefix=/opt/R --enable-memory-profiling --enable-R-shlib --with-blas --with-lapack && \
    make -j4 && \
    make install

# Create symbolic links for R and Rscript
RUN rm /usr/bin/R && \
    rm /usr/bin/Rscript && \
    ln -s /opt/R/bin/R /usr/bin/R && \
    ln -s /opt/R/bin/Rscript /usr/bin/Rscript

# Set R environment variables
RUN echo 'Sys.setenv(CC = "gcc", CXX = "g++")' >> ~/.Rprofile && \
    mkdir -p /usr/share/doc/R/html/ && \
    Rscript -e 'install.packages("devtools", repos="https://cloud.r-project.org/")' && \
    Rscript -e 'pkgbuild::check_build_tools(debug = TRUE)'

# Create the 'sudo' group and a user 'dockeruser' with a password 'password'
RUN getent group sudo || groupadd sudo && \
    useradd -rm -d /home/dockeruser -s /bin/bash -g root -G sudo -u 1000 dockeruser && \
    echo 'dockeruser:password' | chpasswd

# Add dockeruser to sudoers
RUN echo 'dockeruser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set up SSH key generation for root
RUN ssh-keygen -A

# Expose port 22 for SSH access
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
