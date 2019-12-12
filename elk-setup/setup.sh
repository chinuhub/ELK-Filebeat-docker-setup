sudo chown -R root filebeat/filebeat.yml
sudo chown -R root filebeat/configs
sudo chmod -R go-w filebeat/configs/
sudo chmod -R go-w filebeat/filebeat.yml

#sudo sysctl -w vm.max_map_count=262144
#allowing docker to write to logs and data folder (by giving write permission to group)
#sudo chmod 757 logstash/data
#sudo chmod 757 logstash/logs
#sudo chmod 775 elasticsearch/data
#sudo chmod 775 elasticsearch/logs

