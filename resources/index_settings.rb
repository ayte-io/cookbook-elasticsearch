# frozen_string_literal: true

resource_name :elasticsearch_index_settings

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: 8)

attribute :index, [String, Symbol], name_attribute: true
attribute :content, [String, Hash], required: true

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods

  def endpoint
    "#{new_resource.index}/_settings"
  end
end

action :apply do
  to_request_resource(type: :put, path: endpoint) do
    body new_resource.content
  end
end
