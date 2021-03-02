# Решение задания к модулю 5

# MakeFile
Makefile состоит из двух частей sync и deploy.

## Sync
Sync делает зеркало с сайта https://www.chiark.greenend.org.uk/~sgtatham/bugs-ru.html и собирает контеёнер с nginx на борту, где подкидывает html файлы и конфиг. В конфиге изменён параметр ```index``` на ```bugs.html``` для того чтобы сразу открывалась нужная страница.

## Deploy
Deploy запускает bash-скрипт deploy.sh. Скрипт передаёт собраный образ на удаленный сервер и разворачивает его. Если контейнер уже поднят,  то стопит и удаляет его и поднимает новый.

Для подключения к удаленному серверу по SSH необходимо отредактировать переменые в Makefile ```REMOTE_DOCKER_HOST``` - адрес удаленного сервера и ```USER``` - ползователь добавленый в группу Docker.

## CronTab
В cronTab добавляется следующее, ```{Script Directory}``` заменить ан директорию со скриптами и markfile/

```bash
SHELL=/bin/bash

45 3 * * 6 make -f {Script Directory}\Makefile -C {Script Directory} sync && make -f {Script Directory}\Makefile -C {Script Directory} deploy 
```
