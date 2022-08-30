# Docker-compose

El docker-compose.yml cuenta con los servicios de grafana, loki, prometheus, y collect_exporter, pero falta la instalacion de collectd en el servidor y la de promtail en el cliente, además de habilitar mod_status (server-status) en este último.

Si no se encuentra docker y docker-compose instalado visitar el siguiente [enlace.](https://www.hostinger.es/tutoriales/instalar-docker-centos7)

# Habilitar mod_status (server-status)
```
https://httpd.apache.org/docs/2.4/mod/mod_status.html
```

# Collectd
Este servicio debe ser instalado en el servidor.
[Instalar collectd](https://gryzli.info/2017/12/03/centos-7-installing-collectd-and-collectd-web/)

dependencia de collectd:
```
apt-get install collectd-apache
```
Plugins utilizados para collectd:
- [Network](https://collectd.org/wiki/index.php/Plugin:Network)
- [Apache](https://docs.wavefront.com/integrations_collectd_apache.html)
```
LoadPlugin network
<Plugin network>
      Server "10.10.2.101" "25826"
</Plugin>

LoadPlugin "apache"
<Plugin "apache">
        <Instance "mod_status-10.10.2.167">
         URL "http://10.10.2.167/server-status?auto"
        </Instance>

        <Instance "mod_status-10.10.2.168">
         URL "http://10.10.2.168/server-status?auto"
        </Instance>
</Plugin>
```

## Promtail
Este servicio debe ser instalado en los clientes,
[Link de instalación](https://sbcode.net/grafana/install-promtail-service/)
La configuracio utilizada en el archivo de configuracion de promtail es:
```
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: 'http://10.10.2.101:3100/loki/api/v1/push'

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/httpd/access_log
```
Para ejecutar docker-compose.yml
```
docker-compose up -d
```
Ingresar a la url de Grafana ```http://<servidor>:3000```
En grafana ingresar el archivo ````grafana_dashboard.json```` para generar los tableros tableros
