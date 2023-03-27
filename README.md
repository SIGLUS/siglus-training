# Build local training server

### Install
```shell
# git clone repository
git clone https://github.com/SIGLUS/siglus-training.git

# goto the folder siglus-training
cd siglus-training

# replace settings.env file, ask TW to get the new settings.env file, it's for security reason

# connect internet and pull docker images (this may take a long time depend on your network condition)
sudo docker-compose pull

# start docker containers
sudo docker-compose up -d

# wait for about 10 minutes until all docker containers ready

# restore uat DB dump file, ask TW to get the file
./restore-db.sh <the absolute path of the uat DB dump file>

# wait for about 10 minutes until DB file restore successfully

# goto web portal
open http://localhost
```

### Reinstall
```shell
# if your machine shutdown or restart, you can restart local training server
# stop first
sudo docker-compose down

# then start
sudo docker-compose up -d

# wait for a few minutes

# goto web portal
open http://localhost
```
