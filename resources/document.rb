# frozen_string_literal: true

resource_name :elasticsearch_document

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: 8)

attribute :index, [String, Symbol], required: true
attribute :type, [String, Symbol, NilClass], required: false
attribute :id, [String, Symbol], name_attribute: true
attribute :source, [String, Hash], required: true
attribute :refresh, [TrueClass, FalseClass], default: false

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods

  def endpoint
    [new_resource.index, new_resource.type, new_resource.id]
      .reject(&:nil?)
      .join('/')
  end

  def create_request_resource(name, &block)
    delegate = to_request_resource(name: name) do
      path endpoint
      if new_resource.refresh
        parameters(refresh: nil)
      end
    end
    delegate.instance_exec(&block) if block
  end
end

action :create do
  create_request_resource("#{target_name}/#{endpoint}: put") do
    type :put
    body new_resource.source
  end
end

action :remove do
  create_request_resource("#{target_name}/#{endpoint}: delete") do
    ignore_missing true
    type :delete
  end
end
