#!/bin/sh

ROOT_DIR=/usr/share/nginx/html

# Replace env vars in JavaScript files
echo "Replacing env constants in application with variable values"
for file in $ROOT_DIR/js/app.*.js* $ROOT_DIR/index.html $ROOT_DIR/precache-manifest*.js;
do
  echo "Processing $file ...";

  sed -i 's|VUE_APP_FRONT_CONFIG_URL|'${VUE_APP_FRONT_CONFIG_URL}'|g' $file 
  sed -i 's|VUE_APP_MAP_CONFIG_URL|'${VUE_APP_MAP_CONFIG_URL}'|g' $file
  sed -i 's|VUE_APP_GEOSERVER_URL|'${VUE_APP_GEOSERVER_URL}'|g' $file 
  sed -i 's|VUE_APP_API_BASE_URL|'${VUE_APP_API_BASE_URL}'|g' $file

done

echo "Starting Nginx..."
nginx -g 'daemon off;'