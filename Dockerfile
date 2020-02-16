FROM ubuntu:bionic
RUN apt update && apt -y upgrade
RUN apt-get -y install cython python-pip python wget git dpkg-dev cmake g++ gcc binutils libx11-dev \
        libxpm-dev libxft-dev libxext-dev libboost-all-dev gfortran libssl-dev libpcre3-dev \
        xlibmesa-glu-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio-dev \
        graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev python-dev libxml2-dev libkrb5-dev \
        libgsl0-dev libqt4-dev rsync nano vim gnuplot

RUN wget https://root.cern/download/root_v6.18.04.Linux-ubuntu18-x86_64-gcc7.4.tar.gz &&\
         tar xf root_v6.18.04.Linux-ubuntu18-x86_64-gcc7.4.tar.gz
RUN mv root /opt/root && rm root_v6.18.04.Linux-ubuntu18-x86_64-gcc7.4.tar.gz
RUN rm -rf root root_v6.18.04.Linux-ubuntu18-x86_64-gcc7.4.tar.gz

RUN wget https://launchpad.net/mg5amcnlo/2.0/2.7.x/+download/MG5_aMC_v2.7.0.tar.gz &&\
         tar xf MG5_aMC_v2.7.0.tar.gz 
RUN mv MG5_aMC_v2_7_0 /opt/mg5 && rm -rf MG5_aMC_v2_7_0 MG5_aMC_v2.7.0.tar.gz

ENV ROOTSYS=/opt/root
ENV PATH=$PATH:$ROOTSYS/bin:/opt/mg5/bin:/opt/lhapdf6/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib:/opt/lhapdf6/lib
ENV DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ROOTSYS/lib
ENV PYTHONPATH=/opt/lhapdf6/lib/python2.7/site-packages/

RUN wget http://fastjet.fr/repo/fastjet-3.3.3.tar.gz && tar xf fastjet-3.3.3.tar.gz
RUN cd fastjet-3.3.3 && ./configure --prefix=/opt/fastjet --enable-allplugins --enable-static=no \
        --enable-pyext && make && make check && make install
RUN rm fastjet-3.3.3.tar.gz && rm -rf fastjet-3.3.3

RUN echo "auto_update = 0" >> /opt/mg5/input/mg5_configuration.txt && echo "fastjet=/opt/fastjet/bin/fastjet-config" >> /opt/mg5/input/mg5_configuration.txt
RUN echo "install pythia8" >> /install.mg5 && mg5_aMC install.mg5
RUN chmod -R 777 /opt && mkdir -p /.local/share/nano/ && mkdir -p /root/.local/share/nano/ && chmod -R 777 /root/.local && chmod -R 777 /.local 

CMD /opt/mg5/bin/mg5_aMC
