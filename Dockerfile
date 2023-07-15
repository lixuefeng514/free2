FROM ubuntu:20.04

# 安装需要的软件包并指定版本
RUN apt-get update && apt-get install -y --no-install-recommends \
  qemu-kvm=1.0.0-2ubuntu2.9 \
  firefox-esr=68.11.0esr-1~deb10u1 \
  xfce4=4.12.3 \
  tightvncserver=1.3.10-1build1 \
  wget=1.20.1-1.1ubuntu2

# 安装 noVNC
RUN wget -O novnc.tar.gz https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz \
  && tar -xzf novnc.tar.gz -C /opt

# 安装 Proot 
RUN curl -fsSL -o proot.deb https://proot.gitlab.io/proot/bin/proot_7.2.1-13_amd64.deb && \
  dpkg -i proot.deb

# 生成随机密码
RUN echo '235623' > /tmp/vncpass

# 配置 VNC 服务
RUN mkdir ~/.vnc \
  && vncpasswd -f /tmp/vncpass > ~/.vnc/passwd \
  && chmod 600 ~/.vnc/passwd

# 拷贝启动脚本
COPY start.sh /
RUN chmod +x /start.sh  

EXPOSE 6080
CMD ["/start.sh"]
