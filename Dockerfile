FROM nginx

# Add web application
COPY dist /usr/share/nginx/html

# Add nginx configuration
COPY docker/nginx.default.conf /etc/nginx/conf.d/default.conf

# Add custom entrypoint
COPY docker/entrypoint.sh /entrypoint.sh

# Configure default env variables
ENV VUE_APP_FRONT_CONFIG_URL=http://localhost:80/AppConfig.json \
    VUE_APP_MAP_CONFIG_URL=http://localhost:80/MapConfig.json \
    VUE_APP_GEOSERVER_URL=https://development.onesaitplatform.com/geoserver/ \
    VUE_APP_API_BASE_URL=http://localhost:80/

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
