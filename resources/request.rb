# frozen_string_literal: true

resource_name :elasticsearch_request

METHOD_VARIANTS = %w[get post put delete]
  .flat_map { |element| [element, element.upcase] }
  .flat_map { |element| [element, element.to_sym] }
  .freeze
DEFAULT_TIMEOUT = 8

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: DEFAULT_TIMEOUT)

attribute :type, [String, Symbol], default: :get, equal_to: METHOD_VARIANTS
attribute :path, String, required: false
attribute :body, required: false
attribute :headers, Hash, required: false
attribute :parameters, Hash, default: {}
attribute :ignore_missing, [TrueClass, FalseClass], default: false

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods
end

action :execute do
  request = to_request do |builder|
    builder.method = new_resource.type
    if new_resource.authorization
      builder.authorization = new_resource.authorization
    elsif new_resource.user || new_resource.password
      builder.basic_auth(new_resource.user, new_resource.password)
    end
    builder.timeout = new_resource.timeout || DEFAULT_TIMEOUT
  end

  response = request.execute
  # noinspection RubyResolve
  is_ignored_404 = response.code == 404 && new_resource.ignore_missing
  should_raise = !is_ignored_404 && (response.errors? || response.code >= 400)
  raise response.to_s if should_raise
  new_resource.updated_by_last_action(true)
end
