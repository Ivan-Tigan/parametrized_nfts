set -x
tezos-client --endpoint https://ithacanet.ecadinfra.com/ config update
admin_address="tz1NCZX5YK8qRNtJzRyYEagRs73d4FSV4Ztp"
compiled=$(./ligo compile contract $1 -e $2 --no-warn --protocol ithaca)
#storage=$(./ligo compile expression cameligo --init-file $3 $4 --no-warn --protocol ithaca)
storage=$(./ligo compile storage $3 $4 --no-warn -e $2 --protocol ithaca)
tezos-client originate contract $1 transferring 0 from $admin_address running "$compiled" --init "$storage" --burn-cap 100000.59525 --storage-limit 100000000 --force
