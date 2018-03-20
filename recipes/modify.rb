# make sure we have java installed
include_recipe 'java'

user 'opc'

# put chefed in the group so we can make sure we don't remove it by managing cool_group
group 'root' do
  members 'opc'
  action :create
end

# Install Tomcat 9.0.5 to the default location
tomcat_install 'modify' do
  tarball_uri 'http://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.6/bin/apache-tomcat-9.0.6.tar.gz'
  tomcat_user 'opc'
  tomcat_group 'root'
end


# Drop off our own server.xml that uses a non-default port setup
cookbook_file '/opt/tomcat/conf/server.xml' do
  source 'server.xml'
  owner 'opc'
  group 'root'
  mode '0644'
  notifies :restart, 'tomcat_service[modify]'
end

remote_file '/opt/tomcat/webapps/illuminate.war' do
  owner 'opc'
  mode '0644'
  source 'nexus_repo_link'
  
end

# start the helloworld tomcat service 
tomcat_service 'helloworld' do
  action [:start, :enable]
  tomcat_user 'opc'
  tomcat_group 'root'
end