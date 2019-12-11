This directory has all the resources requried to start the docker containers for nginx.

On a your laptop you can use the default configuration files. But for AL testing and production
settings special config files are required, and are named accordingly.

Running on laptop:

The docker container needs to know the ip of your laptop, please get the eth0 interface IP address and
add it in the server directive in the backend block of conf/nginx.conf file, line #23 as if this writing.

 upstream backend  {
        # The keepalive parameter sets the maximum number of idle keepalive connections
        # to upstream servers that are preserved in the cache of each worker process. When
        # this number is exceeded, the least recently used connections are closed.
        #keepalive 100;
        server  192.168.1.2:8080; # Actual host ip address. localhost or 127.0.0.1 won't work inside the container
    }

Run: pmm-nginx.sh script to install the docker container.
The app path 'pmm' goes to the tomcat webapp that is installed as pmm.war

Running on CDNs:

Each CDN has two scripts to start the containers for the two nginx instances.
The scripts map their respective nginx configuration file to: /etc/nginx/nginx.conf

Please note that the the configuration files should be owned by the user id: 999, in order
for the changes to be visible inside the container when the file is edited and the new configuration
is applied from the host.

For example, you can apply the edited configuration with:
docker exec pmm-nginx nginx -t
docker exec pmm-nginx nginx -s reload

Note that cdn1 runs nginx instances on two different hosts, while as cdn2 and cdn3 run both the
nginx (n) and tomcat (t) on the same host.

cdn1 --> n1 --> t1 (nginx-deploy-cdn1-n1.sh)
            --> t2
     --> n2 --> t1 (nginx-deploy-cdn1-n2.sh)
            --> t2

cdn2 --> n1 -> t1 (nginx-deploy-cdn2-t1.sh)
         n2 -> t2 (nginx-deploy-cdn2-t2.sh)

cdn3 --> n1 -> t1 (nginx-deploy-cdn3-t1.sh)
         n2 -> t2 (nginx-deploy-cdn3-t2.sh) 

The configuration files are kept in the 'conf' sub directory with the respective names.
The log files and html and media files are mapped from the host directory.
The conf/nginx.conf is for setting up the nginx container on a localhost for testing.

For amuselabs.com and staging.com, there are two special configurations and they also have configuration for
the SSL support. The configuration for both these servers is as below.

amuselabs.com --> n1 --> t1 (nginx-deploy-with-ssl-al.sh)
staging.amuselabs.com --> n1 --> t1 (nginx-deploy-with-ssl-staging.sh)

Maintenance mode:
There is a special configuration called maintenance.conf which is also volume mapped, so that it can
be edited on the host. This is for moving the site to the maintenance mode when desired. In order to
apply maintenance configuration, you need to save a copy of the original mounted conf file and copy the
maintenance.conf to the mounted conf file and reload nginx with the new configuration.

For example:
Switch to maintenance mode:
sudo cp nginx_staging.conf conf.saved
sudo cp maintenance.conf  nginx_staging.conf
docker exec pmm-nginx nginx -t
docker exec pmm-nginx -s reload

Enter the application mode:
sudo cp conf.saved nginx_staging.conf
docker exec pmm-nginx nginx -t
docker exec pmm-nginx nginx -s reload

Please make sure that the nginx auto restart on the host system (if nginx is installed) with the following cmd on all the production servers. Otherwise, the docker
nginx container will not star due to conflict in the port usage.

sudo update-rc.d nginx disable
