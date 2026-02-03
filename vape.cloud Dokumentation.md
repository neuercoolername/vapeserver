## installation of vapegateway
### Build Rasberry OS Lite via Rasberry Imager
User: `vape`
Hostname: `vape-gateway-X`

### Install Software
General System Update
```bash
sudo apt update
sudo apt upgrade
sudo apt install vim gdb-multiarch libffi-dev
```
pyocd
```bash
# note the dependency on libffi-dev. without pyocd cannot be installed
python -m venv .venv
source .venv/bin/activate
python -m pip install -U pyocd
```
cloudflared
https://github.com/cloudflare/cloudflared/issues/1167

```bash
sudo dpkg --add-architecture arm # see link
# add Repo
curl -L https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-archive-keyring.gpg >/dev/null
echo "deb [arch=arm signed-by=/usr/share/keyrings/cloudflare-archive-keyring.gpg] https://pkg.cloudflare.com/cloudflared any main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
# install
sudo apt update
sudo apt install cloudflared
```
### Cloudflare Configuration
TODO

### Gateway Konfiguration
The script `vape-connector.sh` starts all the necessary commands. The service `vape-connector.service` starts the connector script.
#### install service
```bash
# Make wrapper executable
chmod +x /home/vape/vapeserver/vape-connector.sh
# Install systemd unit
sudo cp /home/vape/vapeserver/vape-connector.service /etc/systemd/system/vape-connector.service
# Reload systemd units,  enable at boot and start vape-commector
sudo systemctl daemon-reload
sudo systemctl enable vape-connector.service
sudo systemctl start vape-connector.service
```
#### view logs
```bash
journalctl -u vape-connector.service -f
```
