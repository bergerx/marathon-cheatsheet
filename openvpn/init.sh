docker run --rm -it -v $(pwd)/openvpn:/etc/openvpn kylemanna/openvpn \
  ovpn_genconfig -d -D -N \
    -u tcp://$PUBLIC_VPN_IP:$PUBLIC_VPN_PORT \
    -p "dhcp-option DNS $SLAVE1_IP" \
    -p "route $MESOS_NETWORK $MESOS_NETMASK"
echo -e "yes\n\n" | docker run -e DEBUG=1 --rm -i -v $(pwd)/openvpn:/etc/openvpn kylemanna/openvpn ovpn_initpki nopass
docker run --rm -it -v $(pwd)/openvpn:/etc/openvpn kylemanna/openvpn easyrsa build-client-full mesos nopass
docker run --rm -it -v $(pwd)/openvpn:/etc/openvpn kylemanna/openvpn ovpn_getclient mesos > mesos.ovpn
sudo chown -R `whoami`. openvpn
docker build -t docker-registry-infra.marathon.mesos:5000/openvpn .
docker push docker-registry-infra.marathon.mesos:5000/openvpn
