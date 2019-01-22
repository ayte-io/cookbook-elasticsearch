# frozen_string_literal: true

resource_name :elasticsearch_index_merge

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: 8)

attribute :index, [String, Symbol, Array], name_attribute: true
attribute :max_num_segments, [Integer, NilClass]
attribute :only_expunge_deletions, [TrueClass, FalseClass, NilClass]
attribute :flush, [TrueClass, FalseClass, NilClass]

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods
end

action :execute do
  indices = new_resource.index
  indices = indices.to_s.split(',') unless indices.is_a?(Array)
  indices.reject!(&:empty?)
  path = "#{indices.join(',')}/_forcemerge"
  parameters = {}
  # noinspection RubyResolve
  unless new_resource.max_num_segments.nil?
    parameters[:max_num_segments] = new_resource.max_num_segments
  end
  unless new_resource.only_expunge_deletions.nil?
    parameters[:only_expunge_deletions] = new_resource.only_expunge_deletions
  end
  unless new_resource.flush.nil?
    parameters[:flush] = new_resource.flush
  end

  to_request_resource(type: :post, path: path) do
    parameters parameters
  end
end
