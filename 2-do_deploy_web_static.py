#!/usr/bin/python3
"""
Fabric script that distributes an archive to your web servers
"""

from datetime import datetime
from fabric.api import *
import os

env.hosts = ["35.174.200.137", "3.85.136.72"]
env.user = "ubuntu"


def do_deploy(archive_path):
    """Archive distributor"""
    try:
        try:
            if os.path.exists(archive_path):
                arc_tgz = archive_path.split("/")
                arg_save = arc_tgz[1]
                arc_tgz = arc_tgz[1].split('.')
                arc_tgz = arc_tgz[0]

                """Upload archive to the server"""
                put(archive_path, '/tmp')

                """Save folder paths in variables"""
                uncomp_fold = '/data/web_static/releases/{}'.format(arc_tgz)
                tmp_location = '/tmp/{}'.format(arg_save)

                """Run remote commands on the server"""
                run('sudo mkdir -p {}'.format(uncomp_fold))
                run('sudo tar -xvzf {} -C {}'.format(tmp_location, uncomp_fold))
                run('sudo rm {}'.format(tmp_location))
                run('sudo mv {}/web_static/* {}'.format(uncomp_fold, uncomp_fold))
                run('sudo rm -rf {}/web_static'.format(uncomp_fold))
                run('sudo rm -rf /data/web_static/current')
                run('sudo ln -sf {} /data/web_static/current'.format(uncomp_fold))
                run('sudo service nginx restart')
                return True
            else:
                print('File does not exist')
                return False
        except Exception as err:
            print(err)
            return False
    except Exception:
        print('Error')
        return False
