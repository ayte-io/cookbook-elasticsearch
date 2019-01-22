# frozen_string_literal: true

resource_name :elasticsearch_bulk_request

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods
define_common_attributes(timeout: 32)

attribute :content, required: true
attribute :index, [String, Symbol, NilClass]
attribute :type, [String, Symbol, NilClass]

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods
end

action :execute do
  endpoint = [new_resource.index, new_resource.type, '_bulk']
    .reject(&:nil?)
    .join('/')

  content = new_resource.content
  if content.is_a?(Array)
    content = content
      .map { |item| item.is_a?(String) ? item : ::JSON.dump(item) }
      .join("\n")
  end
  content += "\n" if content.is_a?(String) && !content.end_with?("\n")

  # noinspection RubyResolve
  delegate = elasticsearch_request "#{target_name}/#{endpoint}" do
    type :post
    path endpoint
    body content
  end

  copy_common_attributes(delegate)
end
