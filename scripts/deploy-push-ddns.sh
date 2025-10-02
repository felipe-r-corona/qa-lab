#!/bin/bash

TARGET_IP="$1"
REMOTE_USER="ficorp"
TMP_DIR="/tmp/push-ddns-deploy"
REMOTE_SCRIPT="$TMP_DIR/deploy-push-ddns-remote.sh"

if [ -z "$TARGET_IP" ]; then
  echo "❌ Error: No target IP provided."
  echo "Usage: $0 <target-ip>"
  exit 1
fi

echo "🚀 Deploying push-ddns to $TARGET_IP..."

# Step 1: Create temp folder on remote
ssh "$REMOTE_USER@$TARGET_IP" "mkdir -p $TMP_DIR"

# Step 2: Rsync files to remote temp
rsync -avz ~/qa-lab/scripts/push-ddns.sh "$REMOTE_USER@$TARGET_IP:$TMP_DIR/"
rsync -avz ~/qa-lab/systemd/push-ddns.service "$REMOTE_USER@$TARGET_IP:$TMP_DIR/"
rsync -avz ~/qa-lab/systemd/push-ddns.timer "$REMOTE_USER@$TARGET_IP:$TMP_DIR/"

# Step 3: Create remote deployment script
ssh "$REMOTE_USER@$TARGET_IP" "cat > $REMOTE_SCRIPT" <<'EOF'
#!/bin/bash

echo "🔧 Ensuring ddns-pusher user exists..."
id -u ddns-pusher &>/dev/null || useradd -r -s /usr/sbin/nologin ddns-pusher

echo "🔧 Installing push-ddns components..."
mkdir -p /opt/push-ddns
mv /tmp/push-ddns-deploy/push-ddns.sh /opt/push-ddns/
mv /tmp/push-ddns-deploy/push-ddns.service /etc/systemd/system/
mv /tmp/push-ddns-deploy/push-ddns.timer /etc/systemd/system/
chmod +x /opt/push-ddns/push-ddns.sh
chown -R ddns-pusher:ddns-pusher /opt/push-ddns

echo "🔄 Reloading systemd..."
systemctl daemon-reexec
systemctl daemon-reload

echo "✅ Enabling and starting push-ddns.timer..."
systemctl enable --now push-ddns.timer

echo "🧪 Verifying status..."
systemctl status push-ddns.timer --no-pager

echo "🧹 Cleaning up..."
rm -rf /tmp/push-ddns-deploy
EOF

# Step 4: Run remote script with sudo
ssh -t "$REMOTE_USER@$TARGET_IP" "sudo bash $REMOTE_SCRIPT"

echo "✅ Deployment to $TARGET_IP complete."
