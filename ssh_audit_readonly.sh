#!/usr/bin/env bash 
echo "SSH client:" 
ssh -V 2>&1 
echo 
echo "SSH server service status (read-only):" 
if command -v systemctl >/dev/null 2>&1; then 
  systemctl --no-pager --full status ssh 2>&1 | head -n 8 || 
  systemctl --no-pager --full status sshd 2>&1 | head -n 8 || true 
else 
  echo "systemctl not available" 
fi 
echo 
echo "Common SSH hardening settings in config (if readable):" 
if [[ -r /etc/ssh/sshd_config ]]; then 
  grep -E 
'^[[:space:]]*(PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|MaxAuthTries)' 
/etc/ssh/sshd_config || echo "No matching explicit settings; defaults/includes may apply" 
else 
  echo "Server configuration not readable or not present" 
fi 
