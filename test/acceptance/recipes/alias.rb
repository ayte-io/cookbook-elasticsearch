elasticsearch_alias 'alias-1:1' do
  port 9201
  name '1'
  index %i[alpha beta]
  action :include
end

elasticsearch_alias 'alias-1:2' do
  port 9201
  name '1'
  index :beta
  action :exclude
end

elasticsearch_alias 'alias-1:2' do
  port 9201
  name '1'
  index :gamma
  action :exclude
end

elasticsearch_alias 'alias-2:1' do
  port 9201
  name '2'
  index %i[alpha beta]
  action :create
end

elasticsearch_alias 'alias-2:2' do
  port 9201
  name '2'
  index :alpha
  action :create
end

elasticsearch_alias 'alias-3:1' do
  port 9201
  name '3'
  index %i[alpha beta]
end

elasticsearch_alias 'alias-3:2' do
  port 9201
  name '3'
  action :remove
end
