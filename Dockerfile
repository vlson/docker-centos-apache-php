#新生成的镜像是基于registry.cn-hangzhou.aliyuncs.com/centos-server/centos6:latest镜像
From registry.cn-hangzhou.aliyuncs.com/centos-server/centos6:latest
MAINTAINER by lxj <lxj370832@163.com>
#安装wget
RUN yum -y install wget
RUN mkdir /package
WORKDIR /package

#此处gcc是必须的，否则会影响confiugre
RUN yum install -y gcc* make apr-devel apr apr-util apr-util-devel pcre-devel
#Apache2.4中里这3种依赖包就需要用新的，yum上的rpm包版本太低了
RUN wget http://archive.apache.org/dist/apr/apr-1.5.2.tar.bz2
RUN wget http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.bz2
RUN wget http://jaist.dl.sourceforge.net/project/pcre/pcre/8.10/pcre-8.10.zip

#安装解压ZIP格式文件的unzip
RUN yum -y install unzip
RUN tar -jxf apr-1.5.2.tar.bz2 && tar -jxf apr-util-1.5.4.tar.bz2 && unzip pcre-8.10.zip

#编译安装依赖包
WORKDIR apr-1.5.2
RUN ./configure --prefix=/usr/local/apr
RUN make 
RUN make install

WORKDIR /package/apr-util-1.5.4
RUN ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/bin/apr-1-config
RUN make 
RUN make install

WORKDIR /package/pcre-8.10
RUN ./configure --prefix=/usr/local/pcre
RUN make 
RUN make install

#下载并解压源码包
WORKDIR /package
RUN wget http://archive.apache.org/dist/httpd/httpd-2.4.20.tar.gz 
RUN tar -zxvf httpd-2.4.20.tar.gz
WORKDIR httpd-2.4.20
RUN ./configure --prefix=/usr/local/apache --enable-so --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-pcre=/usr/local/pcre 
RUN make 
RUN make install

#修改apache配置文件
RUN sed -i 's/#ServerName www.example.com:80/ServerName localhost:80/g' /usr/local/apache/conf/httpd.conf

# 启动服务
RUN /usr/local/apache/bin/httpd

#复制服务启动脚本并设置权限
ADD run.sh /usr/local/sbin/run.sh
RUN chmod 755 /usr/local/sbin/run.sh
#开放80端口
EXPOSE 80
CMD ["/usr/local/sbin/run.sh"]

