from __future__ import print_function
import docker
import requests

__author__ = 'vsitzmann'

def run_container(container, command, in_dir='input', out_dir='output'):
    docker_client = docker.Client('unix:///var/run/docker.sock')
    host_config = docker_client.create_host_config(binds=[in_dir+':/input', out_dir+':/output'])

    try:
        container_instance = docker_client.create_container(host_config=host_config,
                                                            volumes=[in_dir, out_dir],
                                                            image=container,
                                                            tty=True,
                                                            command=command)
    except requests.ConnectionError as e:
        print("Error creating the container: %s\nHint: check if your user account has read and write access on /var/run/docker.sock."%e.message)

    docker_client.attach(container_instance)
    docker_client.start(container_instance)
    print("Docker container finished with exit code %d"%docker_client.wait(container_instance))
