from __future__ import print_function
from builtins import input
import docker
import requests
import sys
import subprocess
import st_exceptions

__author__ = 'vsitzmann'

def check_docker_machine(machine='default'):
    try:
        _ = subprocess.check_call(['docker-machine', '-v'])
    except OSError:
        raise st_exceptions.MachineNotInstalled("docker-machine is required, but not installed. Please install docker-machine.")

    try:
        _ = subprocess.check_output(['docker-machine', 'status', machine])
        print("docker-machine %s is running." % machine)
    except subprocess.CalledProcessError:
        print("Starting docker-machine %s..." % machine)

        try:
            _ = subprocess.check_output(['docker-machine', 'start', machine])
        except subprocess.CalledProcessError:
            create_machine_query = input('Would you like to create the machine now? (y/n)')

            if create_machine_query.lower() == 'y':
                status = subprocess.call(['docker-machine', 'create', '-d', 'virtualbox', machine])

                if status:
                    raise st_exceptions.MachineSetupError("Error creating the docker machine.")
                else:
                    print("The machine %s is up and running!" % machine)

def run_container(container, command, in_dir='input', out_dir='output', machine='default'):
    '''
    in_dir and out_dir should be named /input and /output respectively

    Args:
        container:
        command:
        in_dir:
        out_dir:

    Returns:

    '''

    platform = sys.platform

    if platform == 'linux2':
        docker_client = docker.Client('unix:///var/run/docker.sock')
    else:
        check_docker_machine(machine)
        docker_client = docker.from_env(assert_hostname=False)

    host_config = docker_client.create_host_config(binds=[in_dir+':/input', out_dir+':/output'])

    try:
        container_instance = docker_client.create_container(host_config=host_config,
                                                            volumes=[in_dir, out_dir],
                                                            image=container,
                                                            tty=True,
                                                            command=command)
    except requests.ConnectionError as e:
        print("Error creating the container: %s."%e.message)

    docker_client.attach(container_instance)
    docker_client.start(container_instance)
    print("Docker container finished with exit code %d"%docker_client.wait(container_instance))

    # Remove the container after running it.
    docker_client.remove_container(container_instance)
