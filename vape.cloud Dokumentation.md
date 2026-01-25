## installation of vapegateway
### Build Rasberry OS Lite via Rasberry Imager
User: `vape`
Hostname: `vape-gateway-X`
### Install Software
General System Update
```bash
sudo apt update
sudo apt upgrade
```
pyocd
```bash
apt install libffi-dev # dependency. without pyocd cannot be installed
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
TOOO

### Gateway Konfiguration
#### idea
- run pyocd / semihosting as a systemd unit
- run socat as a systemd unit
- run slattach 
