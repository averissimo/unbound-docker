#!/bin/bash

latest=$(ls | grep -E "^[1-9]" | sort --version-sort | tail -n 1)

echo "latest version is: $latest"

cp -r $latest custom-av

ls

oldpwd=$(pwd)

cd custom-av

cat Dockerfile | \
sed -E "s/^( *curl)/\\1 --cacert \/etc\/ssl\/certs\/ca-certificates.crt/g"  | \
sed -E "s/( *enable-ec_nistp_64_gcc_128.*)/# \\1 # edited by av/g" | \
sed "s/Matthew Vance/André Veríssimo/g" | \
sed "s/name=\"mvance/name=\"betashil/g" | \
sed -E "s/(UNBOUND_DOWNLOAD_URL=https:\/\/nlnetlabs.nl\/downloads\/unbound\/unbound)-[0-9+]\.[0-9]+\.[0-9]+(\.tar\.gz)/\\1-latest\\2/g" | \
sed -E "s/(.*)(UNBOUND_SHA256=.*)/\\1# \\2/g" | \
sed -E "s/(echo \"[$][{]UNBOUND_SHA256)/# \\1/g" | \
sed -E "s/(cd unbound-)[0-9+]\.[0-9]+\.[0-9]( && )/\\1*\\2/g" | \
sed "s/cloudflare.com/sapo.pt/g" > Dockerfile

cat unbound.sh | \
sed -E "s/.*include: \/opt\/unbound\/etc\/unbound\/srv-records\.conf.*//g" | \
sed -E "s/(chown _unbound:_unbound \/opt\/unbound\/etc\/unbound\/var) && \\\\.*/\\1/g" | \
sed -E "s/^\/opt\/unbound\/sbin\/unbound-anchor.*//g" | \
sed -E "s/^(exec \/opt\/unbound\/sbin\/unbound )/#1\n#2\n#3\n#4\n\n\\1/g" | \
sed "s/#1/# Only build root.key if it doesn't exist already/" | \
sed "s/#2/if [ \! -f \/opt\/unbound\/etc\/unbound\/var\/root.key ]; then/" | \
sed "s/#3/       \/opt\/unbound\/sbin\/unbound-anchor -a \/opt\/unbound\/etc\/unbound\/var\/root.key/" | \
sed "s/#4/fi/" > unbound.sh

cd $oldpwd
