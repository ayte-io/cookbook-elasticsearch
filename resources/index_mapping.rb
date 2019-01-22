# frozen_string_literal: true

resource_name :elasticsearch_index_mapping

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: 8)

attribute :index, [String, Symbol], name_attribute: true
attribute :type, [String, Symbol, NilClass], default: :_doc
attribute :content, [String, Hash], required: true

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods

  def endpoint
    "#{new_resource.index}/_mapping/#{new_resource.type}"
  end
end

action :apply do
  name = "#{target_name}/#{endpoint}"
  to_request_resource(name: name, type: :put, path: endpoint) do
    body new_resource.content
  end
end
