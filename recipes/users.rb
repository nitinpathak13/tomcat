#
# Cookbook:: tomcat
# Recipe:: users
#
# Copyright:: 2020, The Authors, All Rights Reserved.

root = node['tomcat']['root']

template "#{root}/conf/tomcat-users.xml" do
  source 'tomcat-users.xml.erb'
end

service 'tomcat' do
  subscribes :restart, "template[#{root}/conf/tomcat-users.xml]", :immediately
end
