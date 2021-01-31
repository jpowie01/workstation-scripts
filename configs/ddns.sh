echo url="https://www.duckdns.org/update?domains={{ ddns.domain }}&token={{ ddns.token }}&ip=" | curl -k -o /etc/ddns/ddns.log -K -
