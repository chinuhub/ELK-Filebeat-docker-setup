# this script sets up a fresh nginx container.
# it expects a conf directory with conf, html and media
# it creates all dirs under the BASEDIR.

cd nginx-docker-build
docker build -t pmm-nginx .
cd -

###### Config block #########
export CONTAINER_NAME=pmm-nginx # make sure this is unique on your system
export BASE_DIR=`pwd`
###### End config block #########

# mapped volumes, so that we can configure nginx, have access to the logs, html and media 
# Mounted directories for the logs, nginx.conf, html, and media files
export LOGS_DIR=$BASE_DIR/logs
export CONF_DIR=$BASE_DIR/conf
export HTML_DIR=$BASE_DIR/html
export MEDIA_DIR=$BASE_DIR/media
export NGINX_CONF_FILE=$BASE_DIR/conf/nginx_cdn2_t1.conf  # default configuration 

chown 999:999 $NGINX_CONF_FILE $CONF_DIR/maintenance.conf # nginx will be able to read the config changes on the host with id 999 as the file owner 

mkdir $LOGS_DIR

docker run -dit \
 --name $CONTAINER_NAME \
 --restart unless-stopped \
 -v $LOGS_DIR:/var/log/nginx \
 -v $CONF_DIR/logrotate.conf:/etc/logrotate.d/nginx \
 -v $NGINX_CONF_FILE:/etc/nginx/nginx.conf \
 -v $CONF_DIR/maintenance.conf:/etc/nginx/maintenance.conf \
 -v $HTML_DIR:/usr/share/nginx/html \
 -v $MEDIA_DIR:/media \
 -p 80:80 nginx:1.15.5 
