#!/bin/bash
 [[ $(nmcli d | grep -wo connected) ]] || { echo "Device not Connected!!!!!" ; exit; }

sudo date -s "$(wget --method=HEAD -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-9)"
