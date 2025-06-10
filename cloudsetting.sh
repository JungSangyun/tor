#!/bin/bash 

sudo apt-get update
sudo apt-get install git -y
sudo apt-get install vim -y

git clone https://github.com/JungSangyun/2021_Project.git

cd ./2021_Project

chmod 755 ./install-tor.sh

sudo ./install-tor.sh
sudo mv /etc/tor/torrc /etc/tor/torrc.backup

TORRC_PATH="/etc/tor/torrc"

# 루트 권한 확인
if [ "$EUID" -ne 0 ]; then
  echo "이 스크립트는 루트 권한으로 실행해야 합니다."
  exit 1
fi

# 추가할 설정 내용
read -r -d '' CONFIG << EOF

# Added by setup script
Nickname toreseach
ORPort 12345 IPv4Only
ExitRelay 0
DirCache 0
AddressDisableIPv6 1
ControlPort 9051
MaxAdvertisedBandwidth 15 MBytes
BandwidthRate 15 MBytes
RelayBandwidthRate 15 MBytes
CookieAuthentication 1
RunAsDaemon 1
EOF

# 백업 후 추가
cp "$TORRC_PATH" "$TORRC_PATH.bak.$(date +%F_%T)"
echo "$CONFIG" >> "$TORRC_PATH"

echo "torrc 파일에 설정을 추가했습니다. (백업: $TORRC_PATH.bak)"


sudo service tor restart
sudo apt install nyx -y