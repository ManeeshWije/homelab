- For Pi's, k3sup needs these flags set inside `/boot/firmware/cmdline.txt`
  - cgroup_enable=cpuset
  - cgroup_memory=1
  - cgroup_enable=memory
- Since we are also using NVME hats, we should add this flag inside `/boot/firmware/config.txt`
  - dtparam=pciex1_gen=3
- If using wireless and router does auto band switching from 2.4ghz to 5ghz, make sure you edit NetworkManager settings to prefer one
- Might need to install these on the rpi node for longhorn
    ```
    sudo apt update
    sudo apt install -y open-iscsi
    sudo systemctl enable iscsid
    sudo systemctl start iscsid
    sudo apt install -y nfs-common
    ```
- dnsmasq config (dont need this anymore since I'm running pihole as our dns server, but this is what I had before)
    ```
    port=53
    domain-needed
    bogus-priv
    listen-address=::1,127.0.0.1,192.168.40.49
    address=/wijeproject.com/192.168.40.49
    address=/*.wijeproject.com/192.168.40.49
    address=/.wijeproject.com/192.168.40.49
    local=/wijeproject.com/
    expand-hosts
    domain=wijeproject.com
    server=8.8.8.8
    server=8.8.4.4
    cache-size=4000
    ```
