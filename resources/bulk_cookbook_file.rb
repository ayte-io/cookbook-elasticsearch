# frozen_string_literal: true

resource_name :elasticsearch_bulk_cookbook_file

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: 32)

attribute :path, [String, Symbol], required: true, name_property: true
attribute :cookbook, [String, Symbol, NilClass]
attribute :index, [String, Symbol, NilClass]
attribute :type, [String, Symbol, NilClass]

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods
end

action :execute do
  cookbook = new_resource.cookbook || new_resource.cookbook_name
  cookbook_version = run_context.cookbook_collection[cookbook]
  cookbook_path = cookbook_version.preferred_filename_on_disk_location(
    run_context.node,
    :files,
    @new_resource.path
  )

  # noinspection RubyResolve
  resource_name = "#{target_name}:#{new_resource.name}"
  delegate = elasticsearch_bulk_file resource_name do
    path cookbook_path
    index new_resource.index
    type new_resource.type
  end
  copy_common_attributes(delegate)
end
