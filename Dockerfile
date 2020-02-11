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
ENV ROOTSYS=/opt/root
ENV PATH=$PATH:$ROOTSYS/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib
ENV DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ROOTSYS/lib

RUN wget https://launchpad.net/mg5amcnlo/2.0/2.6.x/+download/MG5_aMC_v2.6.7.tar.gz &&\
         tar xf MG5_aMC_v2.6.7.tar.gz 
RUN mv MG5_aMC_v2_6_7 /opt/mg5 
RUN rm -rf MG5_aMC_v2_6_7 MG5_aMC_v2.6.7.tar.gz
ENV PATH=$PATH:/opt/mg5/bin

RUN wget http://fastjet.fr/repo/fastjet-3.3.3.tar.gz && tar xf fastjet-3.3.3.tar.gz
RUN cd fastjet-3.3.3 && ./configure --prefix=/opt/fastjet --enable-allplugins --enable-static=no \
        --enable-pyext && make -j$(nproc) && make check && make install
RUN rm fastjet-3.3.3.tar.gz && rm -rf fastjet-3.3.3

RUN wget http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-2.06.09.tar.gz && \
        tar xf HepMC-2.06.09.tar.gz
RUN cd HepMC-2.06.09 && ./configure --prefix=/opt/hepmc2 --with-momentum=GEV --with-length=MM && \
        make -j$(nproc) all && make install
RUN rm -rf HepMC-2.06.09 HepMC-2.06.09.tar.gz

RUN wget https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.2.3.tar.gz && \
        tar xf index.html?f=LHAPDF-6.2.3.tar.gz 
RUN cd LHAPDF-6.2.3 && ./configure --prefix=/opt/lhapdf6 && make -j$(nproc) && make check && make install
RUN rm -rf LHAPDF-6.2.3 index.html?f=LHAPDF-6.2.3.tar.gz 

RUN wget http://home.thep.lu.se/~torbjorn/pythia8/pythia8244.tgz && tar xf pythia8244.tgz
RUN cd pythia8244 && ./configure --prefix=/opt/pythia8 --cxx-common="-fPIC" \
        --with-fastjet3 --with-fastjet3-include="/opt/fastjet/include" --with-fastjet3-lib="/opt/fastjet/lib" \
        --with-gzip --with-gzip-include="/usr/include" --with-gzip-lib="/usr/lib" \
        --with-hepmc2 --with-hepmc2-include="/opt/hepmc2/include" --with-hepmc2-lib="/opt/hepmc2/lib" \
        --with-lhapdf6 --with-lhapdf6-include="/opt/lhapdf6/include" --with-lhapdf6-lib="/opt/lhapdf6/lib" \
        --with-python --with-python-include="/usr/include/python2.7" --with-python-lib="/usr/lib/python2.7" \
        --with-root --with-root-include="/opt/root/include" --with-root-lib="/opt/root/lib" \
        && make -j$(nproc) && make install
RUN rm -rf pythia8244 pythia8244.tgz

RUN wget http://madgraph.phys.ucl.ac.be/Downloads/MG5aMC_PY8_interface/MG5aMC_PY8_interface_V1.0.tar.gz \
        && mkdir MG5aMC_PY8_interface_V1.0 && tar xf MG5aMC_PY8_interface_V1.0.tar.gz -C /MG5aMC_PY8_interface_V1.0
RUN cd /MG5aMC_PY8_interface_V1.0 && ./compile.py /opt/pythia8 /opt/mg5
RUN mkdir -p /opt/mg5/HEPTools/MG5aMC_PY8_interface && cd /MG5aMC_PY8_interface_V1.0  && cp ./MG5aMC_PY8_interface MG5AMC_VERSION_ON_INSTALL PYTHIA8_VERSION_ON_INSTALL \
        VERSION MultiHist.h SyscalcVeto.h /opt/mg5/HEPTools/MG5aMC_PY8_interface 
RUN rm -rf MG5aMC_PY8_interface_V1.0 MG5aMC_PY8_interface_V1.0.tar.gz

COPY mg5_configuration.patch /
RUN cd /opt/mg5/input/ && patch < /mg5_configuration.patch

RUN chmod -R 777 /opt && mkdir -p /.local/share/nano/ && mkdir -p /root/.local/share/nano/ && chmod -R 777 /root/.local && chmod -R 777 /.local
