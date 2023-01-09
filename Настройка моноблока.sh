#!/bin/sh

myhostname=$(hostname)
myhostname=$(kdialog --title="Настройка системы" --inputbox "Введите имя компьютера" $myhostname)
echo $myhostname
pkexec bash -c 'rm -f /etc/machine-id && rm -f /var/lib/dbus/machine-id && dbus-uuidgen --ensure && systemd-machine-id-setup && hostnamectl hostname '$myhostname''
sleep 5

echo "Подключение к сети event"
nmcli d wifi connect "event" password 123qweqwe
sleep 5

echo "Создание учетной записи teacher"
useradd teacher && gpasswd -a teacher wheel && chpasswd <<<"teacher:callmeadmin"
sleep 5

echo "Создание учетной записи student"
useradd student && chpasswd <<<"student:student"
sleep 5

echo "Автовход для student"
sed -i'.bak' -E -e 's,^Session.+,Session=plasma,' -e 's,^User.+,User=student,' /etc/X11/sddm/sddm.conf
sleep 5

echo "Обновление системы"
if apt-get update && apt-get -y dist-upgrade && update-kernel -f && apt-get clean; then
echo "Успех!"
else
apt-get update && apt-get -y dist-upgrade && update-kernel -f && apt-get clean
fi
sleep 5

echo "Обновление списка пакетов epm"
if epm ei; then
echo "Успех!"
else
epm ei
fi
sleep 5

echo "Установка Visual studio code"
epm play code
sleep 5

echo "Установка PascalABC.net"
apt-get -y install pascalabcnet
sleep 5

echo "Установка Pycharm"
epm play pycharm
sleep 5

echo "Установка wine"
epm --auto play wine
sleep 5 

echo "Удаление стандартной учетной записи"
userdel -rf user
sleep 5

echo "Изменение пароля root"
chpasswd <<<"root:rjvuytoer"
sleep 5

echo "Мы закончили перезагружаемся..."
sleep 5
reboot
