#/usr/bin/env bash

sudo cp /usr/share/X11/locale/en_US.UTF-8/Compose /usr/share/X11/locale/en_US.UTF-8/Compose.bak
sed 's/ć/ç/g' < /usr/share/X11/locale/en_US.UTF-8/Compose | sed 's/Ć/Ç/g' > Compose
sudo mv Compose /usr/share/X11/locale/en_US.UTF-8/Compose
