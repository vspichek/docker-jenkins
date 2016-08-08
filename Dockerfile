FROM centos:7.2.1511

ARG rh_epel_url=http://linux.mirrors.es.net/fedora-epel/7
ARG rh_base_url=http://centos.eecs.wsu.edu/7.2.1511/
ARG rh_xtra_url=http://centos.eecs.wsu.edu/7.2.1511/extras
RUN for v in rh_{epel,base,xtra}_url; do echo ${!v} > /etc/yum/vars/$v; done
COPY overlay-rh_repos /

COPY overlay-jenkins_repo /

RUN yum --disablerepo=* --enablerepo=bingit-* --enablerepo=jenkins install -y \
          java-1.8.0-openjdk-headless jenkins initscripts dejavu-sans-fonts fontconfig \
          git \
          ansible \
          docker  && yum clean all

RUN find /lib/systemd/system/sysinit.target.wants \
         /lib/systemd/system/multi-user.target.wants \
         /lib/systemd/system/local-fs.target.wants \
         /lib/systemd/system/local-fs.target.wants \
         /etc/systemd/system/*.wants \
         /lib/systemd/system/sockets.target.wants/*udev* \
         /lib/systemd/system/sockets.target.wants/*initctl* \
      \! -type d \
| grep -v systemd-tmpfiles-setup.service \
| xargs rm -f

RUN systemctl enable jenkins

ENV container docker

VOLUME ["/sys/fs/cgroup", "/tmp", "/run", "/run/lock"]

CMD ["/usr/sbin/init"]
