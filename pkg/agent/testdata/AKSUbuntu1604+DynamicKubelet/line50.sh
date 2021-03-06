[Unit]
Description=Kubelet
ConditionPathExists=/usr/local/bin/kubelet


[Service]
Restart=always
EnvironmentFile=/etc/default/kubelet
SuccessExitStatus=143
ExecStartPre=/bin/bash /opt/azure/containers/kubelet.sh
ExecStartPre=/bin/mkdir -p /var/lib/kubelet
ExecStartPre=/bin/mkdir -p /var/lib/cni
ExecStartPre=/bin/bash -c "if [ $(mount | grep \"/var/lib/kubelet\" | wc -l) -le 0 ] ; then /bin/mount --bind /var/lib/kubelet /var/lib/kubelet ; fi"
ExecStartPre=/bin/mount --make-shared /var/lib/kubelet


ExecStartPre=/sbin/sysctl -w net.ipv4.tcp_retries2=8
ExecStartPre=/sbin/sysctl -w net.core.somaxconn=16384
ExecStartPre=/sbin/sysctl -w net.ipv4.tcp_max_syn_backlog=16384
ExecStartPre=/sbin/sysctl -w net.core.message_cost=40
ExecStartPre=/sbin/sysctl -w net.core.message_burst=80

ExecStartPre=/sbin/sysctl -w net.ipv4.neigh.default.gc_thresh1=4096
ExecStartPre=/sbin/sysctl -w net.ipv4.neigh.default.gc_thresh2=8192
ExecStartPre=/sbin/sysctl -w net.ipv4.neigh.default.gc_thresh3=16384

ExecStartPre=-/sbin/ebtables -t nat --list
ExecStartPre=-/sbin/iptables -t nat --numeric --list


ExecStartPre=/usr/local/bin/configure_azure0.sh

ExecStart=/usr/local/bin/kubelet \
        --enable-server \
        --node-labels="${KUBELET_NODE_LABELS}" \
        --v=2  \
        --volume-plugin-dir=/etc/kubernetes/volumeplugins \
        --config /etc/default/kubeletconfig.json \
        $KUBELET_FLAGS \
        $KUBELET_REGISTER_NODE $KUBELET_REGISTER_WITH_TAINTS

[Install]
WantedBy=multi-user.target