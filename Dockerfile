FROM nginx
COPY ./www.chiark.greenend.org.uk/~sgtatham/*.html /usr/share/nginx/html/
COPY ./default.conf /etc/nginx/conf.d/default.conf
