class web_static {
  # Install nginx if it's not already installed
  package { 'nginx':
    ensure => installed,
  }

  # Create necessary directories
  file { '/data':
    ensure => directory,
  }

  file { '/data/web_static':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0775',
  }

  file { '/data/web_static/releases':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0775',
  }

  file { '/data/web_static/shared':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0775',
  }

  file { '/data/web_static/releases/test':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0775',
  }

  # Create index.html file
  file { '/data/web_static/releases/test/index.html':
    ensure  => file,
    owner   => 'ubuntu',
    group   => 'ubuntu',
    mode    => '0644',
    content => '<html>
  <head>
  </head>
  <body>
    ALX School
  </body>
</html>',
  }

  # Create symbolic link
  file { '/data/web_static/current':
    ensure => 'link',
    target => '/data/web_static/releases/test',
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0775',
    require => File['/data/web_static/releases/test'],
  }

  # Set up nginx configuration
  file { '/etc/nginx/sites-available/default':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /data/web_static/releases/test;
        index index.html;
        server_name _;
        location /hbnb_static/ {
            alias /data/web_static/current/;
            autoindex off;
        }
    }',
    notify => Service['nginx'],
  }

  # Start/restart nginx service
  service { 'nginx':
    ensure => running,
    enable => true,
  }
}

