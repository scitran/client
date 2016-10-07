from setuptools import setup

with open('requirements.txt', 'r') as f:
    install_requires = [line.rstrip() for line in f]

# XXX license?

dist = setup(
    name='Scitran Client',
    version='0.0.1',
    description='Official Scitran Client',
    author='vistalab',
    install_requires=install_requires,
    packages=['scitran_client'],
    package_data={'': ['stAuth.json.example']},
    platforms=['CPython 2.7'],
)
