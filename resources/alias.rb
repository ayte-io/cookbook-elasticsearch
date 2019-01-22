# frozen_string_literal: true

resource_name :elasticsearch_alias

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: 2)

attribute :name, [String, Symbol], name_attribute: true
attribute :index, [String, Symbol, Array], default: []

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods

  def indices
    indices = new_resource.index
    indices = indices.to_s.split(',') unless indices.is_a?(Array)
    indices.map(&:to_s).map(&:strip).reject(&:empty?)
  end

  def alias_endpoint
    "_alias/#{new_resource.name}"
  end

  def current_indices
    request = to_request(path: alias_endpoint)
    response = execute_request(request)
    case response.code
    when 404
      []
    when 200
      response.body.keys
    else
      raise "Unexpected response: #{response}"
    end
  end

  def compile_request_resource(inclusions: [], exclusions: [])
    operations = []
    inclusions.each do |index|
      operations.append(add: { index: index, alias: new_resource.name })
    end
    exclusions.each do |index|
      operations.append(remove: { index: index, alias: new_resource.name })
    end
    to_request_resource(type: :post, path: '_aliases') do
      body(actions: operations)
    end
  end
end

action :create do
  existing = current_indices
  exclusions = existing - indices
  inclusions = indices - existing
  compile_request_resource(inclusions: inclusions, exclusions: exclusions)
end

action :include do
  inclusions = indices - current_indices
  unless inclusions.empty?
    compile_request_resource(inclusions: inclusions)
  end
end

action :exclude do
  exclusions = indices & current_indices
  unless exclusions.empty?
    compile_request_resource(exclusions: exclusions)
  end
end

action :remove do
  exclusions = current_indices
  unless exclusions.empty?
    compile_request_resource(exclusions: exclusions)
  end
end
