"""
A bash script masquerading as a python script.
"""
import json
import os
import subprocess

stackscript_data = {
    'DJANGO_SECRET_KEY': os.environ.get('DJANGO_SECRET_KEY'),
    'POSTGRES_PASSWORD': os.environ.get('POSTGRES_PASSWORD'),
    'POSTGRES_USER': os.environ.get('POSTGRES_USER'),
    'POSTGRES_DB': os.environ.get('POSTGRES_DB')
    }

subprocess.run(['linode-cli', 'linodes', 'create',
                '--type', 'g6-nanode-1',
                '--region', 'us-west',
                '--image', 'linode/ubuntu20.04',
                '--root_pass', os.environ.get('ROOT_PASS'),
                '--stackscript_id', '996353',
                '--authorized_keys', f"{subprocess.run(['cat', os.path.expanduser('~/.ssh/id_rsa.pub')], capture_output=True).stdout.decode('utf-8').strip()}",
                '--stackscript_data', json.dumps(stackscript_data),
                '--label', 'honey'])
