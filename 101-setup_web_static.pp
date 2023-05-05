# Install and config Ngnix
exec { 'update':
  command => '/usr/bin/env sudo apt-get -y update',
}
-> exec {'instNginx':
  command => '/usr/bin/env sudo apt-get -y install nginx',
}
-> exec {'crea1':
  command => '/usr/bin/env sudo mkdir -p /data/web_static/releases/test/',
}
-> exec {'crea2':
  command => '/usr/bin/env sudo mkdir -p /data/web_static/shared/',
}
-> exec {'fake':
  command => '/usr/bin/env sudo echo "html fake" > /data/web_static/releases/test/index.html',
}
-> exec {'simlink':
  command => '/usr/bin/env sudo ln -sf /data/web_static/releases/test /data/web_static/current',
}
-> exec {'chown':
  command => '/usr/bin/env sudo chown -R ubuntu:ubuntu /data',
}
-> exec {'configure':
  command => '/usr/bin/env sudo sed -i "/listen 80 default_server/a location /hbnb_static/ { alias /data/web_static/current/;}" /etc/nginx/sites-available/default',
}
-> exec {'restart':
  command => '/usr/bin/env sudo service nginx restart',
}

