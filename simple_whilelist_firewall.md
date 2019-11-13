iptables -I INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT # allow free outgoing connections
iptables -I INPUT -s ${ALLOWED_SOURCE_IP_OR_RANGE} -j ACCEPT # could be specified multiple times, x.x.x.x or x.x.x.x/range
iptables -A INPUT -s 0.0.0.0/0 -j DROP # WARNING: DROP rule could only be inserted after whiltelist specified
iptables -vnL # show
