#!/bin/bash
# Usage: rollback.sh <artifact> <version>

artifact=$1
version=$2

/etc/init.d/${artifact} stop

rm ${artifact} # softlink

ln -s ${artifact}-${version} ${artifact}

/etc/init.d/${artifact} start

while ( ! curl http://locahost:8080/status 2>/dev/null |grep online )
do
  echo "Waiting for web-app to come online."
  sleep 10
done

