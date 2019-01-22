elasticsearch_document '1' do
  port 9201
  index :alpha
  type :doc
  source 'id' => 1
end

elasticsearch_document '2' do
  port 9201
  index :alpha
  type :doc
  source id: 2
  action %i[create remove]
end
