from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route('/update', methods=['GET'])
def update_dns():
    hostname = request.args.get('hostname')
    ip = request.args.get('ip')
    if not hostname or not ip:
        return "Missing hostname or IP", 400

    # Update /etc/hosts
    subprocess.run(["sudo", "/usr/local/bin/update-hosts.sh", hostname, ip])

    # Restart dnsmasq
    subprocess.run(["sudo", "systemctl", "restart", "dnsmasq"])
    return f"Updated {hostname} → {ip}", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
