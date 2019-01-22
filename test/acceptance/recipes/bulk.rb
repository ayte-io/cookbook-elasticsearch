elasticsearch_bulk_request 'bulk' do
  port 9201
  index :alpha
  type :doc
  content([
    { index: {_id: '3' } },
    { id: 3 }
  ])
end

elasticsearch_bulk_cookbook_directory 'bulk/cookbook' do
  port 9201
  index :alpha
  type :doc
end

remote_directory '/tmp/acceptance/bulk' do
  source 'bulk/migrated'
end

elasticsearch_bulk_directory '/tmp/acceptance/bulk' do
  port 9201
  index :alpha
  type :doc
end
