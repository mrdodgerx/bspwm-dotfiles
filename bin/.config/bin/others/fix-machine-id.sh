#!/bin/bash
set -e

echo "=== Fixing machine-id issues (safe & network-aware) ==="

# Function to wait until network is online
wait_for_network() {
    echo "[INFO] Waiting for network to come back online..."
    
    # If nm-online exists (NetworkManager), use it
    if command -v nm-online >/dev/null 2>&1; then
        nm-online -q --timeout=30
        return
    fi

    # Fallback: ping test every second
    for i in {1..300}; do
        if ping -c1 8.8.8.8 >/dev/null 2>&1; then
            echo "[INFO] Network is back online."
            return
        fi
        sleep 1
    done

    echo "[WARNING] Network not detected after 30 seconds. Continuing anyway."
}

# 1. Remove old machine-id files
echo "[1] Removing old machine-id files..."
rm -f /etc/machine-id
rm -f /var/lib/dbus/machine-id

# 2. Regenerate machine-id and DBus ID
echo "[2] Regenerating IDs..."
systemd-machine-id-setup
dbus-uuidgen --ensure

# 3. Rebuild initramfs (safe but heavy)
echo "[3] Rebuilding initramfs..."
mkinitcpio -P

# 4. Restart network services
echo "[4] Restarting network services..."
systemctl restart NetworkManager 2>/dev/null || true
systemctl restart wpa_supplicant 2>/dev/null || true

# 4.1 Wait for network to return
wait_for_network

# 5. Reload udev and USB subsystem
echo "[5] Reloading udev rules..."
udevadm control --reload-rules
udevadm trigger

# 6. Clean systemd logs
echo "[6] Cleaning systemd journal..."
journalctl --rotate
journalctl --vacuum-time=1s

# 7. Reinstall dbus (requires network)
echo "[7] Reinstalling D-Bus..."
pacman -Syu --noconfirm dbus

# 8. Clear user cache
echo "[8] Clearing user cache..."
rm -rf ~/.cache/* 2>/dev/null || true

# 9. Fix random seed
echo "[9] Regenerating random seed..."
rm -f /var/lib/systemd/random-seed
systemctl restart systemd-random-seed

echo "=== DONE ==="
echo "Reboot to fully apply the fix."

