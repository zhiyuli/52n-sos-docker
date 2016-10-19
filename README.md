# 52n-sos-docker

# 0) install dependencies

install docker-engine

install psql

## 1) pull image and start container

docker run -p 8383:8080 --name 52n-sos -d zhiyuli/52n-sos:4.3.7

## 2) visit tomcat manager at http://SERVER_IP:8383 (optional)

default user/password: admin/tomcat

## 3) create an empty "sos" db with postgis extension

### 3-1) list all db

psql -h POSTGIS_IP -p 5432 -U DB_USER -c "\l"

### 3-2) create sos db

createdb -h POSTGIS_IP -p 5432 -U DB_USER sos

### 3-3) enable postgis extension in sos db

psql -h POSTGIS_IP -p 5432 -U DB_USER sos -c "CREATE EXTENSION postgis;"

## 4) go through sos configuration in UI

http://SERVER_IP:8383/sos
