from __future__ import print_function
from builtins import input
import docker
import requests
import sys
import subprocess
import st_exceptions
import os

__author__ = 'vsitzmann'


def ensure_docker_machine(machine):
    try:
        subprocess.check_call(['docker-machine', '-v'])
    except OSError:
        raise st_exceptions.MachineNotInstalled(
            "docker-machine is required, but not installed. Please install docker-machine.")

    try:
        subprocess.check_output(['docker-machine', 'status', machine])
        print("docker-machine %s is running." % machine)
    except subprocess.CalledProcessError:
        print("Starting docker-machine %s..." % machine)

        try:
            subprocess.check_output(['docker-machine', 'start', machine])
        except subprocess.CalledProcessError:
            create_machine_query = input('Would you like to create the machine now? (y/n)')

            if create_machine_query.lower() == 'y':
                status = subprocess.call(['docker-machine', 'create', '-d', 'virtualbox', machine])

                if status:
                    raise st_exceptions.MachineSetupError("Error creating the docker machine.")
                else:
                    print("The machine %s is up and running!" % machine)


def add_docker_machine_to_env(machine):
    env_vars_string = subprocess.check_output(['docker-machine', 'env', machine])
    relevant_indices = [1, 3, 5, 7]
    new_env_vars = [env_vars_string.split()[i] for i in relevant_indices]
    new_env_var_dict = dict([env_var_string.replace('\"', '').split('=') for env_var_string in new_env_vars])

    for key, value in new_env_var_dict.iteritems():
        os.environ[key] = value


def run_container(container, command, in_dir='input', out_dir='output', machine='default'):
    '''
    in_dir and out_dir should be named /flywheel/v0/input and /flywheel/v0/output respectively

    Args:
        container:
        command:
        in_dir:
        out_dir:

    Returns:

    '''

    docker_socket = '/var/run/docker.sock'
    if sys.platform == 'linux2' or os.path.exists(docker_socket):
        # This branch is used by linux and by macs with new versions of docker.
        docker_client = docker.Client('unix://{}'.format(docker_socket))
    else:
        # This branch is used by macs with older versions of docker.
        ensure_docker_machine(machine)
        add_docker_machine_to_env(machine)
        docker_client = docker.from_env(assert_hostname=False)

    host_config = docker_client.create_host_config(binds=[
        '{}:/flywheel/v0/input:ro'.format(in_dir),
        '{}:/flywheel/v0/output'.format(out_dir),
    ])
    # using subprocess instead of docker_client.pull(container) so the user can see real-time output
    subprocess.call(['docker', 'pull', container], stderr=subprocess.STDOUT)

    try:
        container_instance = docker_client.create_container(host_config=host_config,
                                                            volumes=[in_dir, out_dir],
                                                            image=container,
                                                            tty=True,
                                                            command=command)
    except requests.ConnectionError as e:
        print('Error creating the container: {}.'.format(e.message))

    docker_client.start(container_instance)
    for item in docker_client.logs(container_instance, stream=True):
        print(item, end='')
    exit_code = docker_client.wait(container_instance)
    print('Docker container finished with exit code {}'.format(exit_code))

    # Remove the container after running it.
    docker_client.remove_container(container_instance)

    if exit_code:
        raise Exception('error')
