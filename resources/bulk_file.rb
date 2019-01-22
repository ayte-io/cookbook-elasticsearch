# frozen_string_literal: true

resource_name :elasticsearch_bulk_file

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods
define_common_attributes(timeout: 32)

attribute :path, name_attribute: true
attribute :index, [String, Symbol, NilClass], default: nil
attribute :type, [String, Symbol, NilClass], default: nil

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods
end

action :execute do
  # noinspection RubyResolve
  delegate = elasticsearch_bulk_request "#{target_name}:#{new_resource.path}" do
    content(lazy { ::File.new(new_resource.path, 'r') })
    index new_resource.index
    type new_resource.type
  end

  copy_common_attributes(delegate)
end
