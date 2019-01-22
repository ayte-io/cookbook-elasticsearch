include_recipe 'ayte-elasticsearch-acceptance::setup'

elasticsearch_status_wait :green do
  port 9201
  authorization 'Bearer kinetic-deer'
  timeout 60
end

include_recipe 'ayte-elasticsearch-acceptance::basic'
include_recipe 'ayte-elasticsearch-acceptance::index'
include_recipe 'ayte-elasticsearch-acceptance::alias'
include_recipe 'ayte-elasticsearch-acceptance::document'
include_recipe 'ayte-elasticsearch-acceptance::bulk'
