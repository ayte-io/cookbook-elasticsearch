elasticsearch_index :alpha do
  port 9201
  action :remove
end

elasticsearch_index :alpha do
  port 9201
  settings '{"index":{"refresh_interval":"2s"}}'
  mapping(
    properties: {
      id: {
        type: :long
      }
    }
  )
  mapping_type :doc
end

elasticsearch_index_merge :alpha do
  port 9201
  max_num_segments 1
  flush true
end

elasticsearch_index :beta do
  port 9201
end

elasticsearch_index :gamma do
  port 9201
end

elasticsearch_index :delta do
  port 9201
  action %i[create remove]
end

elasticsearch_index :epsilon do
  port 9201
  action %i[remove]
end
