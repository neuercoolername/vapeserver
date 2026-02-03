#!/usr/bin/env bash
set -euo pipefail

# ---- Configuration -------------------------------------------------
PORT=4444
TTY=/home/vape/vapeserver/myTTY
ELF=/home/vape/vapeserver/bin/firmware.elf

VENV=/home/vape/vapeserver/.venv
PATH="$VENV/bin:/usr/bin:/bin:/sbin"
export PATH VIRTUAL_ENV="$VENV"
# -------------------------------------------------------------------

cleanup() {
    trap - SIGINT SIGTERM EXIT
    echo "vape-connector: shutting down"
    kill 0
}
trap cleanup SIGINT SIGTERM EXIT

echo "vape-connector: starting pyOCD"
pyocd \
    gdb \
    --semihosting \
    --telnet-port "$PORT" \
    --target py32f002bx5 \
    --pack /home/vape/vapeserver/Puya.PY32F0xx_DFP.*.pack \
    --connect attach \
    --frequency 2m \
    --elf $ELF &

until ss -tuln | grep -q ":$PORT "; do
  echo "Waiting for pyocd to open port $PORT..."
  sleep 1
done

echo "vape-connector: starting GDB"
gdb-multiarch \
    -ex "set confirm off" \
    -ex "set pagination off" \
    -ex "set verbose off" \
    -ex "file $ELF" \
    -ex "target remote localhost:3333" \
    -ex "continue" &

sleep 5

echo "vape-connector: starting socat"
socat -d -ly PTY,link=$TTY,raw,echo=0 TCP:localhost:$PORT,nodelay &

sleep 5

echo "vape-connector: starting slattach"
sudo slattach -L -p slip -s 115200 "$TTY" &

echo "setup sl0 interface"
sudo ip addr add 192.168.190.1 peer 192.168.190.2/24 dev sl0 && \
sudo ip link set mtu 1500 up dev sl0

# If ANY component exits, restart the whole stack
wait -n

echo "vape-connector: component exited, restarting"
exit 1
