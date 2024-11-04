# Openresty gammu-smsd mysql backend service admin panel

Gammu smsd Mysql backend docs: [https://docs.gammu.org/smsd/mysql.html]

Support multiphones and multidaemons: [https://docs.gammu.org/smsd/config.html#multiple-modems]

## Install gammu and gammu-smsd

```
sudo apt install gammu
sudo apt install gammu-smsd

```

## Dependencies

```
sudo luarocks install luasql-mysql MYSQL_INCDIR=/usr/include/mariadb/
sudo luarocks install lua-resty-template

```

## DB connect setting

/db/mysql.lua

```
local db = "smsd"
local db_user = "smsd"
local db_password = ""	

```

## Autofind multiply phones by numbers and make config example


```
dmesg | grep 'ttyUSB' | while read line
do
	if [[ $line == *"attached"* ]]; then	
		port=`echo "$line" | sed 's/.*ttyUSB\(.\)$/\1/'`
		gammu -s $port getussd *XXX# > temp	
		number=`cat temp | sed s/[^0-9]//g`		
		rm temp	
		echo '[gammu]
		device = /dev/ttyUSB'$port'
		connection = at
		
		[smsd]
		service = sql
		Driver = native_mysql
		Host = localhost
		User = smsd
		Password = 
		Database = smsd
		LogFile = '$number'.log
		LogFormat = textall
		RunOnReceive = /root/modems/receive.sh
		PhoneID = '$number > $number'.conf'	
	fi
done

```

## Start multiply gammu-smsd daemons

```
confs=($(find ~+ -name '*.conf'))
for conf in ${confs[@]};do 
	name=`echo "$conf" | sed 's/^\(.*[^\.conf]\).*$/\1/'`;
	gammu-smsd -d -c $conf -p $name.'.pid'
done

```
## Reload configs and phones/modems

```
pids=($(pidof gammu-smsd))
if [ -z "$pids" ] ; then
    echo "Not find smsd daemons"
else
	for pid in ${pids[@]};do 
		kill -SIGHUP $pid
	done
fi
```

## Modems|phones info to csv format

```

confs=($(find ~+ -name '*.conf'))
for conf in ${confs[@]};do 
	name=`echo "$conf" | sed 's/[^0-9]//g'`	
	if [ -n "$1" ]	
	then
		modem=`echo "$1" | sed s/[^0-9]//g | sed 's/.//'`
		if [ "$name" -eq "$modem" ]
		then
			gammu-smsd-monitor -n 1 -C -c $conf |  sed -n 's/^.*GCC \(.*\)$/\1/p' > info.csv
			exit 0
		fi
	else
		gammu-smsd-monitor -n 1 -C -c $conf |  sed -n 's/^.*GCC \(.*\)$/\1/p' >> info.csv
	fi
done

if [ -n "$1" ]	
then
	exit 1
fi

```

