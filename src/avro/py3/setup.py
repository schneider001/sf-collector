import os

from setuptools import setup

setup(
    name = 'SysFlow Processing API',
    version = '0.1',    
    description = ('Runs workflows for deploying deceptions'),    
    packages=['sysflow'],
    package_data={'sysflow': ['schema.avsc']},
    install_requires=['avro-python3==1.8.2',
       'avro-gen==0.3.0',
       'blinker==1.3',
       'chardet==2.3.0',
       'cloud-init==18.2',
       'configobj==5.0.6',
       'cryptography==1.2.3',
       'idna==2.0',
       'Jinja2==2.8',
       'jsonpatch==1.10',
       'jsonpointer==1.9',
       'MarkupSafe==0.23',
       'oauthlib==1.0.3',
       'prettytable==0.7.2',
       'pyasn1==0.1.9',
       'pycurl==7.43.0',
       'pygobject==3.20.0',
       'PyJWT==1.3.0',
       'pyserial==3.0.1',
       'python-apt==1.1.0b1+ubuntu0.16.4.2',
       'python-debian==0.1.27',
       'python-systemd==231',
       'PyYAML==3.11',
       'requests==2.9.1',
       'six==1.10.0',
       'ssh-import-id==5.5',
       'ufw==0.35',
       'unattended-upgrades==0.1',
       'urllib3==1.13.1'],
    scripts=['utils/sysprint'],
    package_dir = {'': 'classes'}
)
