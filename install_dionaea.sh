#!/bin/bash

echo "[+] Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

echo "[+] Installation des dépendances requises..."
sudo apt install -y \
git build-essential libssl-dev libffi-dev \
libcurl4-openssl-dev libpcap-dev python3-pip python3-dev \
libtool automake autoconf cmake pkg-config sqlite3 \
libev-dev libudns-dev libemu-dev \
python3-setuptools python3-yaml libglib2.0-dev \
libnl-3-dev libnl-genl-3-dev libpython3-dev mailutils

echo "[+] Téléchargement de Dionaea..."
cd /opt
sudo git clone https://github.com/DinoTools/dionaea.git
cd dionaea
sudo mkdir -p build
cd build

echo "[+] Compilation de Dionaea..."
sudo cmake ..
sudo make -j$(nproc)
sudo make install

echo "[+] Création du dossier de logs..."
sudo mkdir -p /opt/dionaea/var/dionaea

echo "[+] Création du script de lancement..."
cat <<EOF | sudo tee /usr/local/bin/run-dionaea.sh > /dev/null
#!/bin/bash
/usr/local/bin/dionaea -l all -D -p /opt/dionaea/var/dionaea
EOF

sudo chmod +x /usr/local/bin/run-dionaea.sh

echo "[✓] Installation terminée. Lancez le honeypot avec : sudo run-dionaea.sh"
