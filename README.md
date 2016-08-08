# Jeknins docker

`"Contained"` Jenkins that is able to run containerized jobs in the same Docker

To build, run following once:

    docker build -t centos_jenkins_docker_ansible .

To do behind proxy and/or against RH/Centos repository snapshot(s) do:

    docker build \
      --build-arg http_proxy=http://proxy:port \
      --build-arg https_proxy=http://proxy:port \
      --build-arg rh_base_url=repo_snapshot_1 \
      --build-arg rh_epel_url=repo_snapshot_2 \
      --build-arg rh_xtra_url=repo_snapshot_3 \
      -t centos_jenkins_docker_ansible .

It is your repository to maintain the snapshot(s) and ensure integrity.

To run:

    docker run \
      --name jenkins -d \
      --privileged \
      -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
      -v /var/run/docker.sock:/var/run/docker.sock \
      --tmpfs /run \
      --tmpfs /run/lock \
      -p 127.0.0.1:8080:8080 \
      centos_jenkins_docker_ansible
