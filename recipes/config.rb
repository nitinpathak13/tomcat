#
# Cookbook:: tomcat
# Recipe:: config
#
# Copyright:: 2020, The Authors, All Rights Reserved.

root = node['tomcat']['root']

# server.xml changes, make changes to server.xml.erb

template "#{root}/conf/server.xml" do
  source 'server.xml.erb'
end

service 'tomcat' do
  subscribes :restart, "template[#{root}/conf/server.xml]", :immediately
end

# tomcat-users.xml,make changes to tomcat-users.xml.erb

template "#{root}/conf/tomcat-users.xml" do
  source 'tomcat-users.xml.erb'
end

service 'tomcat' do
  subscribes :restart, "template[#{root}/conf/tomcat-users.xml]", :immediately
end
