#网关254


#新生成的镜像是基于sshd-centos镜像
FROM centos
MAINTAINER by cmsteven
#RUN export PIP-ALIYUN="-i http://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com/pypi/simple/"
WORKDIR /opt/
#http://mirrors.aliyun.com/centos/7/os/x86_64/Packages/wget-1.14-10.el7_0.1.x86_64.rpm
ADD wget-1.14-10.el7_0.1.x86_64.rpm .
RUN chmod 777 wget-1.14-10.el7_0.1.x86_64.rpm
RUN rpm -ivh wget-1.14-10.el7_0.1.x86_64.rpm
RUN wget http://mirrors.aliyun.com/centos/7/os/x86_64/Packages/yum-3.4.3-132.el7.centos.0.1.noarch.rpm
#RUN chmod 777 yum-3.4.3-132.el7.centos.0.1.noarch.rpm
#RUN rpm -ivh yum-3.4.3-132.el7.centos.0.1.noarch.rpm
#安装wget
RUN yum install -y openssh epel-release unzip openssl gcc make file libffi openssl-devel gcc-c++ libffi-devel python-wheel openssl-devel libgsasl-devel cyrus-sasl*
RUN yum update unzip openssl gcc make file libffi openssl-devel gcc-c++ libffi-devel python-wheel openssl-devel  libgsasl-devel   cyrus-sasl*
#RUN chkconfig sshd on
#RUN wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz
RUN wget http://10.167.200.102/static/Python-2.7.5.tgz

#ADD Python-3.5.2.tgz .
RUN chmod 777 *
RUN tar -zxvf Python-2.7.5.tgz
WORKDIR /opt/Python-2.7.5/
RUN chmod -R 777 *
RUN ./configure --prefix=/usr/local/python

RUN make 
RUN make install
RUN echo "export PYTHONHOME=/usr/local/python" >> /etc/profile
RUN echo "export PATH=$PYTHONHOME/bin:$PATH" >> /etc/profile
RUN source /etc/profile
#RUN make 
#RUN make install
RUN chmod -R 777 /usr/local/python

RUN echo "/usr/python/lib" >> /etc/ld.so.conf
RUN ldconfig
##RUN ln -s /usr/local/python/bin/python3.5 /usr/bin/python

#RUN python setup.py -i https://pypi.tuna.tsinghua.edu.cn/simple/

#RUN wget https://bootstrap.pypa.io/get-pip.py
ADD get-pip.py .
RUN chmod 777 get-pip.py
RUN python get-pip.py -i https://pypi.tuna.tsinghua.edu.cn/simple/

RUN yum install -y python python-devel python-pip python-tools python-libs openldap-devel

#RUN pip install progressive progressbar  -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
RUN pip install setuptools thrift-sasl flask-babel cryptography virtualenv -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

#升级pip
#RUN yum install -y deltarpm python-pip python-tools git
RUN pip install -U pip setuptools
#RUN pip install --upgrade pip

#下载caravel-kylin源码包 
#RUN git clone https://github.com/rocky1001/caravel.git
#RUN chmod -R 777 caravel
#WORKDIR /opt/caravel
#RUN pip install . -i https://pypi.tuna.tsinghua.edu.cn/simple/

# 安装 caravel
#RUN pip install caravel -i https://pypi.tuna.tsinghua.edu.cn/simple/
RUN pip install caravel -i https://pypi.tuna.tsinghua.edu.cn/simple/

# copy admin password details to /caravel for fabmanager
RUN mkdir /caravel
ADD admin.config /caravel/

# 创建admin用户
RUN fabmanager create-admin --app caravel < /caravel/admin.config
#RUN fabmanager create-admin --app caravel

# 初始化Caravel元数据
RUN caravel db upgrade

# 初始化Caravel默认的用户角色和权限
RUN caravel init

#RUN pip install mysqlclient -i https://pypi.tuna.tsinghua.edu.cn/simple/

## 加载示例数据（可选）
#RUN caravel load_examples

#启动caravel
CMD caravel runserver -d

WORKDIR /opt/
RUN yum install -y git
RUN git clone https://github.com/rocky1001/pykylin.git
RUN chmod 777 pykylin
RUN cd pykylin
WORKDIR /opt/pykylin
RUN pip install .


#从宿主机上复制JDK文件夹
#ADD jdk-8u102-linux-x64.rpm .
#ADD scala-2.11.8.rpm .
#RUN rpm -ivh jdk-8u102-linux-x64.rpm scala-2.11.8.rpm 


#复制容器启动脚本
ADD run.sh /usr/local/sbin/run.sh
#设置脚本权限
RUN chmod 755 /usr/local/sbin/run.sh
CMD ["/usr/local/sbin/run.sh"]
#开放容器的22和8080端口
EXPOSE 8088
EXPOSE 22



