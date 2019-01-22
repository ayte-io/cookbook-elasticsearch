if platform?('debian', 'ubuntu')
  execute 'localectl set-locale LANG=en_US.UTF-8'
  apt_update
  %w[apt-transport-https gnupg2].each(&method(:package))
  apt_update
elsif platform?('centos')
  execute 'yum groupinstall -y "Development Tools"'
end

include_recipe 'java::default'
elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch'
elasticsearch_configure 'elasticsearch' do
  configuration('http.port' => 9201, 'xpack.ml.enabled' => false)
end
elasticsearch_service 'elasticsearch'

service 'elasticsearch' do
  action :restart
end

include_recipe 'ayte-elasticsearch::setup'
