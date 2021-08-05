#!/bin/bash
 
file=/var/www/html/sites/test
echo "Entrypoint"
wget -q https://www.drupal.org/files/projects/drupal-8.9.13.tar.gz
echo "scaricato drupal"
tar -zxf drupal-8.9.13.tar.gz --strip 1
echo "estratto drupal"
#wait-for-it -t 240 elasticsearch:9200
sleep 5
 
if [ ! -e "$file" ]; then
        touch /var/www/html/sites/test
        echo "touch test file"
        echo "eliminato il tar.gz"
        #installing drupal
        cd sites/default
        drush si standard --yes --db-url="mysqli://$DB_USER:$DB_PASSWORD@$DB_HOST/$DB_NAME" --account-pass="$DRUPAL_ADMIN_PASS"
        cd ../../
        drush -y config-set system.performance css.preprocess 0
        chmod 755 sites/default/settings.php
        chmod 777 sites/default/files
 
        #add dashboard to kibana
        #wait-for-it -t 240 elasticsearch:9200
        #wait-for-it -t 240 kibana:5601
        #sleep 20
        #curl -X POST kibana:5601/api/saved_objects/_import?createNewCopies=true -H "kbn-xsrf: true" --form file=@/savedObj.ndjson
 
else 
    echo "Test file exists"
fi 
 
rm drupal-8.9.13.tar.gz
#execute default entrypoint
/usr/local/bin/docker-php-entrypoint -D FOREGROUND
