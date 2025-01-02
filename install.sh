#! /bin/bash
# https://github.com/d-jumper/aaPanel-lifetime

Happy_Bt(){
clear
sleep 5
wget https://github.com/d-jumper/aaPanel-lifetime/raw/refs/heads/main/panel.zip
unzip panel.zip
cd panel

sleep 5
bash update.sh

sleep 5
cd .. && rm -f panel.zip && rm -rf panel && rm install*
sed -i 's|"endtime": -1|"endtime": 999999999999|g' /www/server/panel/data/plugin.json
sed -i 's|"pro": -1|"pro": 0|g' /www/server/panel/data/plugin.json
echo "True" > /www/server/panel/data/licenes.pl
echo "True" > /www/server/panel/data/not_recommend.pl
echo "True" > /www/server/panel/data/not_workorder.pl
rm -rf /www/server/panel/data/bind.pl
chattr +i /www/server/panel/data/plugin.json
}

clear
apt-get update
apt-get upgrade -y
apt-get install liblua5.1-0 curl wget libpangocairo-1.0-0 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon-x11-0 libxcomposite-dev libxdamage1 libxrandr2 libgbm-dev zip -y

ip=`curl -s http://whatismyip.akamai.com/`
cp /etc/hosts /etc/hosts.bak
clear
sleep 5

curl -ksSO "https://raw.githubusercontent.com/d-jumper/aaPanel-lifetime/refs/heads/main/install-aapanel.sh" && wget --no-check-certificate -O install-aapanel.sh "https://raw.githubusercontent.com/d-jumper/aaPanel-lifetime/refs/heads/main/install-aapanel.sh" && chmod +x install-aapanel.sh && clear && sleep 5 && ./install-aapanel.sh 66959f96

clear
sleep 5
Happy_Bt
echo "done"
sleep 5
service cron reload >/dev/null 2>&1
bt restart
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 3306 -j ACCEPT
chattr +i /www/server/panel/logs/request

clear
sleep 5
panel_path=/www/server/panel
port=$(cat $panel_path/data/port.pl)
ufw allow ${port}
apt-get update
apt-get upgrade -y

cat> .profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

clear
bt default
bt
END

clear
sleep 5
bt 6

timedatectl set-timezone Asia/Jakarta
clear
sleep 5
echo "Installation Successfully!"
echo "Use Command => bt ( setting menu )"
bt default
bt
