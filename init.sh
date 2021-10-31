#!/bin/bash
sudo useradd -m git
sudo usermod -aG docker git
sudo mkdir -p /docker-data/gogs-drone/data/gogs/git/.ssh/
sudo ln -s /docker-data/gogs-drone/data/gogs/git/.ssh/ /home/git/.ssh
sudo chown -R git:git /home/git/.ssh
sudo chown -R git:git /docker-data/gogs-drone/data/gogs
sudo mkdir -p /app/gogs/
cat <<\END | sudo tee /app/gogs/gogs
#!/bin/bash
GIT_KEY_ID=$(cat /home/git/.ssh/id_rsa.pub | awk '{ print $3 }')
if ! grep -q "no-port.*$GIT_KEY_ID" /home/git/.ssh/authorized_keys
then
    echo \
    "no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty" \
    "$(cat /home/git/.ssh/id_rsa.pub)" \
    >> /home/git/.ssh/authorized_keys
fi
ssh -p 10022 -o StrictHostKeyChecking=no git@127.0.0.1 \
    SSH_ORIGINAL_COMMAND=$(printf '%q' "$SSH_ORIGINAL_COMMAND") "$0" "$@"
END
sudo chmod 755 /app/gogs/gogs
sudo -u git ssh-keygen -t rsa
