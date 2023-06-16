#!/bin/sh

addgroup -g $GID -S $FTP_USER

adduser -D -G $FTP_USER -h /home/$FTP_USER -s /bin/false -u $UID $FTP_USER

mkdir -p /home/$FTP_USER
chown -R $FTP_USER:$FTP_USER /home/$FTP_USER
echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd

touch /var/log/vsftpd.log /var/log/xferlog
tail -f /var/log/vsftpd.log | tee /dev/stdout &
tail -f /var/log/xferlog | tee /dev/stdout &

sed -i "s/^pasv_address=[0-9.]\+/pasv_address=$EXTERNAL_IP/" /etc/vsftpd.conf
sed -i "s/^pasv_address=[0-9.]\+/pasv_min_port=$PASSIVE_MIN_PORT/" /etc/vsftpd.conf
sed -i "s/^pasv_address=[0-9.]\+/pasv_max_port=$PASSIVE_MAX_PORT/" /etc/vsftpd.conf


exec "$@"
