default['tomcat']['default_version'] = '9'
default['tomcat']['version'] = '9.0.37'
default['tomcat']['remote_url'] = "https://downloads.apache.org/tomcat/tomcat-#{node['tomcat']['default_version']}/v#{node['tomcat']['version']}/bin/apache-tomcat-#{node['tomcat']['version']}.tar.gz"
default['tomcat']['root'] = "/usr/share/tomcat#{node['tomcat']['default_version']}"
