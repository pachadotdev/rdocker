# Use Fedora 40 as the base image
FROM fedora:40

# Install OpenSSH server and other necessary packages
RUN dnf install -y openssh-server passwd sudo && \
    dnf clean all

# Enable SSH service
RUN systemctl enable sshd

# Install Clang and LLVM
RUN dnf install -y --skip-broken 'dnf-command(copr)' 'dnf5-command(copr)' && \
    dnf copr -y enable @fedora-llvm-team/llvm-snapshots && \
    dnf install -y clang llvm

# Install R dependencies
RUN dnf install -y wget which R readline-devel libX11-devel libXt-devel libcxx libcxx-devel harfbuzz-devel fribidi-devel openssl-devel libcurl-devel

# Set environment variables for Clang
ENV CC=clang
ENV CXX=clang++

# Download and extract R source
RUN wget https://cran.r-project.org/src/base/R-4/R-4.4.2.tar.gz -O R-4.4.2.tar.gz && \
    tar -xzvf R-4.4.2.tar.gz && \
    cd R-4.4.2 && \
    echo 'CC="clang"' > config.site && \
    echo 'CXX="clang++ -stdlib=libc++"' >> config.site && \
    echo 'CFLAGS="-g -O3 -Wall -pedantic"' >> config.site && \
    echo 'FFLAGS="-g -O2 -mtune=native"' >> config.site && \
    echo 'CXXFLAGS="-g -O3 -Wall -pedantic -stdlib=libc++"' >> config.site && \
    echo 'MAIN_LD="clang++ -stdlib=libc++"' >> config.site && \
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
RUN echo 'Sys.setenv(CC = "clang", CXX = "clang++")' >> ~/.Rprofile && \
    mkdir -p /usr/share/doc/R/html/ && \
    Rscript -e 'install.packages("devtools", repos="https://cloud.r-project.org/")' && \
    Rscript -e 'pkgbuild::check_build_tools(debug = TRUE)'

# Create the 'sudo' group and a user 'dockeruser' with a password 'password'
RUN groupadd sudo && \
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
