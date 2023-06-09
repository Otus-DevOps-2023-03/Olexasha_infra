#!/bin/bash

START_TIME=$SECONDS

# Добавляем репозиторий монги в сурсы
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list

# Обновляем ссылки и устанавливаем mongodb
apt update -qq
apt install -y mongodb-org

# Запускаем сервис и добавляем его в автозапуск
sudo systemctl start mongod
sudo systemctl enable --now mongod
STATUS=$(systemctl status mongod)

# Проверяем, что сервис активен и добавлен в автозапуск ОС
if [[ $STATUS == *"active (running)"* ]]; then
  echo "[debug] MongoDB is active and running"
else
  echo "[debug] Something went wrong! MongoDB is not running"
fi

if [[ $STATUS == *"enabled"* ]]; then
  echo "[debug] MongoDB is enabled and will start at boot"
else
  echo "[debug] Something went wrong! MongoDB is not enabled"
fi
# shellcheck disable=SC2004
ELAPSED_TIME=$(($SECONDS - $START_TIME))
# shellcheck disable=SC2004
echo -e "\nFinished in $(($ELAPSED_TIME/60/60)) hr, $(($ELAPSED_TIME/60%60)) min, and $(($ELAPSED_TIME%60)) sec\n"
echo "------------------------------------------------"
echo "Installed MongoDB version is:  $(mongod --version)"
