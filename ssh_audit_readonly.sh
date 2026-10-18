
#!/usr/bin/env bash
set -u

echo "SSH Read-Only Audit"
echo "-------------------"

echo
echo "SSH client version:"
ssh -V 2>&1 || true

echo
echo "SSH service status:"
if command -v systemctl >/dev/null 2>&1; then
    systemctl is-active ssh 2>/dev/null ||
    systemctl is-active sshd 2>/dev/null ||
    echo "SSH service is not active or unavailable."
else
    echo "systemctl is unavailable."
fi

echo
echo "SSH server configuration:"
if [[ -r /etc/ssh/sshd_config ]]; then
    grep -E '^[[:space:]]*(Port|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication)[[:space:]]' /etc/ssh/sshd_config ||
    echo "No matching active settings found."
else
    echo "SSH server configuration is unavailable."
fi

echo
echo "SSH host key files:"
ls -l /etc/ssh/ssh_host_* 2>/dev/null ||
echo "No SSH host keys found."

echo
echo "SSH audit completed."
