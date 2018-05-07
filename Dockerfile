# Version: 0.0.1 - Certified Asterisk 13.18-cert3, based on the Dockerfile by Gonzalo Marcote "gonzalomarcote@gmail.com"
FROM centos:latest
MAINTAINER Antonio Alisio "alisio.meneses@gmail.com"
RUN yum -y update
RUN yum -y install vim tar htop epel-release
#RUN yum -y install gcc gcc-c++ make wget subversion libxml2-devel ncurses-devel openssl-devel sqlite-devel libuuid-devel vim-enhanced jansson-devel unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel subversion speex-devel mysql-devel
RUN yum -y install automake gcc gcc-c++ git patch ncurses-devel openssl-devel libxml2-devel unixODBC-devel libcurl-devel libogg-devel libvorbis-devel speex-devel spandsp-devel freetds-devel net-snmp-devel iksemel-devel corosynclib-devel newt-devel popt-devel libtool-ltdl-devel lua-devel sqlite-devel libsqlite3x-devel radiusclient-ng-devel portaudio-devel postgresql-devel libresample-devel neon-devel libical-devel openldap-devel gmime-devel sqlite2-devel mysql-devel bluez-libs-devel jack-audio-connection-kit-devel gsm-devel libedit-devel libuuid-devel jansson-devel subversion git libxslt-devel python-devel wget vim
WORKDIR /usr/src
RUN svn co http://svn.pjsip.org/repos/pjproject/trunk/ pjproject-trunk
WORKDIR /usr/src/pjproject-trunk
RUN ./configure --libdir=/usr/lib64 --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr CFLAGS='-O2 -DNDEBUG'
RUN make dep
RUN make
RUN make install
RUN ldconfig
RUN ldconfig -p | grep pj
WORKDIR /usr/src
RUN wget http://downloads.asterisk.org/pub/telephony/certified-asterisk/asterisk-certified-13.18-cert3.tar.gz
RUN tar -zxvf asterisk-certified-13.18-cert3.tar.gz
WORKDIR /usr/src/asterisk-certified-13.18-cert3
RUN sh contrib/scripts/get_mp3_source.sh
COPY menuselect.makeopts /usr/src/asterisk-certified-13.18-cert3/menuselect.makeopts
RUN ./configure CFLAGS='-g -O2 -mtune=native' --libdir=/usr/lib64
RUN make
RUN make install
RUN make samples
WORKDIR /root
CMD ["/usr/sbin/asterisk", "-vvvvvvv"]
