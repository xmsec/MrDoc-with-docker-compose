#! /usr/bin/env sh
MM=`pwgen -1s`
CREATE_USER=1
CONFIG_FILE='/app/MrDoc/config/config.ini'

if [ ! -f $CONFIG_FILE ]; then
echo "#####Generating configuration file#####"
cat>"${CONFIG_FILE}"<<EOF
[site]
debug = False
[database]
engine = mysql
name = mrdoc
user = jonnyan404
password = www.mrdoc.fun
host = mysql-with-mrdoc
port=3306
[selenium]
driver_path = /usr/lib/chromium/chromedriver
# 详细配置请查阅 https://www.mrdoc.fun/project-1/doc-190/
EOF
else
        echo "#####Configuration file already exists#####"
fi

/bin/bash -c 'wait4db=0;while [ "$wait4db" != "None" ]; do echo -en "\rwaiting for db connection ...."; sleep 3;wait4db=`echo "import django;print(django.db.connection.ensure_connection())" | python3 manage.py shell 2>/dev/null`; done'

echo -e "\ndb is ready!"

python3 /app/MrDoc/manage.py makemigrations && python3 /app/MrDoc/manage.py migrate

if [ $CREATE_USER -eq 1 ]; then
  if [ ! -f $CREATE_USER ]; then
	    touch $CREATE_USER
	        #echo "-- First container startup --user:${USER} pwd:${MM}"
		echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('${USER}', 'www@mrdoc.fun', '${MM}')" | python3 /app/MrDoc/manage.py shell
		    # YOUR_JUST_ONCE_LOGIC_HERE
		echo "-- First container startup --user:${USER} pwd:${MM}"
	    else
		echo "-- Not first container startup --"
  fi
else
	echo "user switch not create"

fi

nohup echo y | python3 /app/MrDoc/manage.py rebuild_index

set -e

# If there's a prestart.sh script in the /app directory, run it before starting
PRE_START_PATH=/app/prestart.sh

echo "Checking for script in $PRE_START_PATH"
if [ -f $PRE_START_PATH ] ; then
	    echo "Running script $PRE_START_PATH"
	        . $PRE_START_PATH
	else
		    echo "There is no script $PRE_START_PATH"
fi

# Start Supervisor, with Nginx and uWSGI
# exec /usr/bin/supervisord
exec /usr/local/bin/uwsgi --ini /etc/uwsgi/uwsgi.ini

