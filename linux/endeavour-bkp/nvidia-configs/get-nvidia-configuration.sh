echo '=== NVIDIA PACKAGES ==='
pacman -Q | grep -Ei 'nvidia|cuda|vulkan|egl'

echo
echo '=== KERNEL ==='
uname -a
pacman -Q | grep '^linux'

echo
echo '=== NVIDIA MODULES ==='
lsmod | grep nvidia

echo
echo '=== NVIDIA DRM ==='
for f in modeset fbdev; do
    if [ -f "/sys/module/nvidia_drm/parameters/$f" ]; then
        printf '%s: ' "$f"
        cat "/sys/module/nvidia_drm/parameters/$f"
    fi
done

echo
echo '=== NVIDIA CONFIG FILES ==='
sudo find /etc -type f \
    \( -iname '*nvidia*' -o -iname '*prime*' \) \
    -print 2>/dev/null

echo
echo '=== MODPROBE CONFIG ==='
sudo rg -i 'nvidia|nouveau|drm' /etc/modprobe.d /etc/modules-load.d 2>/dev/null

echo
echo '=== XORG CONFIG ==='
sudo rg -i 'nvidia|nouveau|drm|prime' /etc/X11 2>/dev/null

echo
echo '=== INITRAMFS ==='
grep -E '^(MODULES|HOOKS|FILES)=' /etc/mkinitcpio.conf 2>/dev/null

echo
echo '=== KERNEL COMMAND LINE ==='
cat /proc/cmdline

echo
echo '=== BOOTLOADER ==='
bootctl status 2>/dev/null || true

echo
echo '=== GPU ==='
lspci -nnk | grep -A3 -E 'VGA|3D|Display'

echo
echo '=== Environment variables ==='
env | grep -Ei 'nvidia|cuda|prime|egl|vulkan'

echo
echo '=== Systemmd Services ==='
systemctl list-unit-files | grep -i nvidia

echo
echo '=== Nvidia service ==='
systemctl --no-pager --type=service | grep -i nvidia

echo '=== DRACUT ==='
sudo cat /etc/dracut.conf.d/nvidia.conf

echo
echo '=== UDEV ==='
sudo cat /etc/udev/rules.d/70-nvidia.rules

echo
echo '=== XORG ==='
sudo cat /etc/X11/xorg.conf

echo
echo '=== NVIDIA I2C XORG ==='
sudo cat /etc/X11/xorg.conf.d/90-nvidia-i2c.conf

echo
echo '=== SYSTEMD-BOOT ==='
sudo cat /efi/loader/loader.conf
sudo sh -c 'for f in /efi/loader/entries/*.conf; do echo "### $f"; cat "$f"; done'

echo
echo '=== FILE OWNERS ==='
for f in \
  /etc/modprobe.d/nvidia.conf \
  /etc/modprobe.d/nvidia-i2c.conf \
  /etc/modprobe.d/nvidia-power-management.conf \
  /etc/udev/rules.d/70-nvidia.rules \
  /etc/dracut.conf.d/nvidia.conf \
  /etc/cdi/nvidia.yaml \
  /etc/X11/xorg.conf \
  /etc/X11/xorg.conf.d/90-nvidia-i2c.conf; do
    echo "### $f"
    pacman -Qo "$f" 2>&1
done
