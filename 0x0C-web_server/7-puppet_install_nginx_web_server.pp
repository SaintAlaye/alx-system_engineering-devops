#!/usr/bin/env bash
# Configure Nginx server to give error 404 page
apt-get update
apt-get -y install nginx
ufw allow 'Nginx HTTP'
chmod -R 755 /var/www
echo 'Hello World' > /var/www/html/index.html

new_config=\
"server {
        listen 80 default_server;
        listen [::]:80 default_server;
               root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                try_files \$uri \$uri/ =404;
        }
        error_page 404 /404.html;
        location  /404.html {
            internal;
        }
        
        if (\$request_filename ~ redirect_me){
            rewrite ^ https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;
        }
}
"
echo "Ceci n'est pas une page" > /var/www/html/404.html

echo "$new_config" > /etc/nginx/sites-available/default

if [ "$(pgrep nginx)" -le 0 ];
then
    service nginx start
else
    service nginx restart
fi;
