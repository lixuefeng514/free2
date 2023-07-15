# 指定基础镜像
FROM ubuntu:20.04

# 安装所需软件包 
RUN apt-get update && apt-get install -y --no-install-recommends \
    qemu-kvm=5.0.0-10ubuntu1 \
    firefox-esr=68.11.0esr-1~deb10u1 \
    xfce4=4.12.3 \
    tightvncserver=1.11.0-1build1 \
    wget=1.20.3-1ubuntu1

# 安装 noVNC
RUN wget https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz -O novnc.tar.gz \
  && tar -xzf novnc.tar.gz -C /opt/novnc --strip-components=1

# 安装 Proot
RUN curl -fsSL -o proot.deb https://proot.gitlab.io/proot/bin/proot_7.2.1-13_amd64.deb \ 
  && dpkg -i proot.deb

# 生成密码文件  
RUN echo "235623" > /tmp/vncpass

# 配置 VNC 
RUN mkdir /etc/vnc \
  && vncpasswd -f /tmp/vncpass > /etc/vnc/passwd \
  && chmod 600 /etc/vnc/passwd

# 拷贝启动脚本
COPY start.sh /
RUN chmod +x /start.sh

# 暴露端口  
EXPOSE 6080

# 容器启动时执行脚本
CMD ["/start.sh"]
#!/bin/bash

vncserver -geometry 1280x800 -depth 24 -localhost -rfbport 5901

cd /opt/novnc
python3 -m http.server 6080 --bind 127.0.0.1 --directory .
