#!/bin/bash -e

sudo apt-get update
sudo apt-get install -y unzip

#############
# Constants #
#############

main_dir=/home/ubuntu/snowplow

# Directories
staging_dir=$main_dir/staging
executables_dir=$main_dir/bin
es_dir=$main_dir/elasticsearch

# Packagaes
collector_package=snowplow_scala_stream_collector_0.9.0.zip
enrich_package=snowplow_stream_enrich_0.10.0.zip
sink_package=snowplow_kinesis_elasticsearch_sink_0.8.0_1x.zip
iglu_server_package=iglu_server_0.2.0.zip
kibana_v=4.0.1

##################
# Install Java 8 #
##################

sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install oracle-java8-installer -y

################################
# Install Kinesis Applications #
################################

wget http://dl.bintray.com/snowplow/snowplow-generic/${collector_package} -P $staging_dir
unzip $staging_dir/${collector_package} -d $executables_dir

wget http://dl.bintray.com/snowplow/snowplow-generic/${enrich_package} -P $staging_dir
unzip $staging_dir/${enrich_package} -d $executables_dir

wget http://dl.bintray.com/snowplow/snowplow-generic/${sink_package} -P $staging_dir
unzip $staging_dir/${sink_package} -d $executables_dir

#######################
# Install Iglu Server #
#######################

wget http://bintray.com/artifact/download/snowplow/snowplow-generic/${iglu_server_package} -P $staging_dir
unzip $staging_dir/${iglu_server_package} -d $executables_dir
sudo -u postgres psql -c "create user snowplow createdb password 'snowplow';" || true
sudo -u postgres psql -c "create database iglu owner snowplow;" || true

#########################
# Install Elasticsearch #
#########################

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/1.4/debian stable main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update -y && sudo apt-get install elasticsearch -y
sudo /usr/share/elasticsearch/bin/plugin --install mobz/elasticsearch-head

##################
# Install Kibana #
##################

wget "https://download.elasticsearch.org/kibana/kibana/kibana-${kibana_v}-linux-x64.zip" -P $staging_dir
sudo unzip $staging_dir/kibana-${kibana_v}-linux-x64.zip -d /opt/
sudo ln -s /opt/kibana-${kibana_v}-linux-x64 /opt/kibana

#################
# Install Nginx #
#################

sudo apt-get -y install nginx apache2-dev

# Set ownership of directory
sudo chown -R ubuntu:ubuntu $main_dir
