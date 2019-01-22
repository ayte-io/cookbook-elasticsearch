# frozen_string_literal: true

resource_name :elasticsearch_index

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: 8)

attribute :index, [String, Symbol], name_attribute: true
attribute :settings, [Hash, String, NilClass]
attribute :mapping, [Hash, String, NilClass]
attribute :mapping_type, [String, Symbol, NilClass], default: :_doc
attribute :active_shards, [Integer, String, NilClass]

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods

  def endpoint
    new_resource.index
  end
end

action :create do
  existence_request = to_request(type: :head, path: endpoint)
  existence_response = existence_request.execute
  if existence_response.code == 404
    to_request_resource(type: :put, path: endpoint) do
      body({})
      unless new_resource.active_shards.nil?
        parameters(wait_for_active_shards: new_resource.active_shards)
      end
    end
  end

  %i[settings mapping].each do |phase|
    value = new_resource.send(phase)
    next unless value
    delegate = send("elasticsearch_index_#{phase}".to_sym, new_resource.name) do
      index new_resource.index
      # noinspection RubyResolve
      type new_resource.mapping_type if phase == :mapping
      content value
    end
    copy_common_attributes(delegate)
  end
end

action :remove do
  to_request_resource(type: :delete, path: endpoint) do
    # noinspection RubyResolve
    ignore_missing true
  end
end
