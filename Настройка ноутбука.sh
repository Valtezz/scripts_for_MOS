#!/bin/sh

myhostname=$(hostname)
myhostname=$(kdialog --title="Настройка системы" --inputbox "Введите имя компьютера" $myhostname)
echo $myhostname
pkexec bash -c 'rm -f /etc/machine-id && rm -f /var/lib/dbus/machine-id && dbus-uuidgen --ensure && systemd-machine-id-setup && hostnamectl hostname '$myhostname''
sleep 5

echo "Подключение к сети event"
nmcli d wifi connect "event" password 123qweqwe ifname  wlp0s20f3
sleep 5

echo "Создание учетной записи admin"
useradd admin && gpasswd -a admin wheel && chpasswd <<<"admin:callmeadmin"
sleep 5

echo "Создание учетной записи teacher"
useradd teacher && chpasswd <<<"teacher:12345678"
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

echo "Установка Chrome"
epm --auto play chrome
sleep 5

echo "Установка teams"
if epm play teams; then
echo "Успех!"
else
epm play teams
fi
sleep 5

echo "Установка anydesk"
if epm play anydesk; then
echo "Успех!"
else
epm play anydesk
fi
sleep 5

echo "Запуск anydesk в автозапуск"
serv anydesk on
sleep 5

echo "Установка пароля для Anydesk"
echo 123QWEqwe | anydesk --set-password
sleep 5

echo "Автовход для teacher"
sed -i'.bak' -E -e 's,^Session.+,Session=plasma,' -e 's,^User.+,User=teacher,' /etc/X11/sddm/sddm.conf
sleep 5

echo "Изменение пароля root"
chpasswd <<<"root:rjvuytoer"
sleep 5

echo "Удаление стандартной учетной записи"
userdel -rf user
sleep 5

echo "Удаление event из списка запомненных сетей"
nmcli connection delete "event"
sleep 5

echo "Вы великолепны отключаемся..."
sleep 5
poweroff