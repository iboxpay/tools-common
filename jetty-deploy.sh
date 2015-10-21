#!/bin/bash
# Usage: jetty-deploy.sh <artifact> <version>

artifact=$1
version=$2

wget https://nexus.iboxpay.com/${artifact}/${version}/${artifact}-${version}.zip

unzip ${artifact}.zip

/etc/init.d/{artifact} stop
rm ${artifact} # softlink

ln -s ${artifact}-${version} ${artifact}

/etc/init.d/${artifact} start

while (! curl http://lolalhost:8080/status 2>/dev/null | grep online )
do
  echo "Waiting for web-app to come online."
done

