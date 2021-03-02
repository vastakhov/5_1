#!/bin/bash
# Собираем образ
docker save bugs-site:latest > /tmp/bugs-site-image.tar
# Передаём образ на удаленный сервер и удаляем с локального сервера
scp -C /tmp/bugs-site-image.tar $1@$2:/tmp/bugs-site-image.tar
rm /tmp/bugs-site-image.tar
# Подключаемся к удаленному докер-серверу и проверяем есть ли уже запущеный контейнер, если есть стопим и удаляем.
export DOCKER_HOST="ssh://$1@$2"
if [ "$(docker ps -q -f name=site-bugs)" ]; 
then
    if [ "$(docker ps -aq -f status=exited -f name=site-bugs)" ]; 
    then
        echo "The container exists and is in the status EXITED"
        echo "Container will be removed"
        docker rm site-bugs
        docker images -a | grep bugs-site | awk '{print $3}' | xargs docker rmi
        echo "Container removed"
    else
        echo "The container exists and is in the status UP"
        echo "Container will be stoped and removed"
        docker stop site-bugs
        docker rm site-bugs
        docker images -a | grep bugs-site | awk '{print $3}' | xargs docker rmi
        echo "Container stoped and removed"        
    fi
    echo "Load image in Docker"
# Подгружаем образ в докер на удаленном сервере
    docker load < /tmp/bugs-site-image.tar
    echo "Start Container"
# Запускаем контейнер
    docker run  --name site-bugs -d -p 80:80 bugs-site:latest
else
echo "Load new image in Docker"
ssh $1@$2 "docker load < /tmp/bugs-site-image.tar"
ssh $1@$2 "rm /tmp/bugs-site-image.tar"
echo "Start new Container"
docker run  --name site-bugs -d -p 80:80 bugs-site:latest
fi
unset DOCKER_HOST
