echo server: > /etc/unbound/unbound.conf.d/$2
grep '^0\.0\.0\.0' $1 | awk '{print "local-data: \""$2" A 0.0.0.0\""}' >> /etc/unbound/unbound.conf.d/$2
