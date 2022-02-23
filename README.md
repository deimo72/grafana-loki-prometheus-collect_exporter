# PracticaNicolasCorrea










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
