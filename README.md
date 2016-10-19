# 52n-sos-docker

### install docker-engine

### install psql

# pull image and start container

docker run -p 8383:8080 --name 52n-sos -d zhiyuli/52n-sos:4.3.7

# visit tomcat manager at http://<IP>:8383 (optional)

default user/password: admin/tomcat

## create an empty "sos" db with postgis extension

# #list all db

psql -h <IP_Postgis> -p 5432 -U <db_user> -c "\l"

## create sos db

createdb -h <IP_Postgis> -p 5432 -U <db_user> sos

## enable postgis extension in sos db

psql -h <IP_Postgis> -p 5432 -U <db_user> sos -c "CREATE EXTENSION postgis;"

# go through sos configuration in UI

http://<IP>:8383/sos
