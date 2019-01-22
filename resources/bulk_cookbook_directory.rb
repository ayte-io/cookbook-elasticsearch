# frozen_string_literal: true

resource_name :elasticsearch_bulk_cookbook_directory

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: 8)

attribute :path, name_attribute: true
attribute :cookbook, [String, Symbol, NilClass], required: false
attribute :pattern, [String, Symbol], default: '**.{json,jsons}'
attribute :index, [String, Symbol, NilClass]
attribute :type, [String, Symbol, NilClass]

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods
end

action :execute do
  cookbook_name = new_resource.cookbook || new_resource.cookbook_name
  cookbook = run_context.cookbook_collection[cookbook_name]
  files = cookbook.relative_filenames_in_preferred_directory(
    run_context.node,
    :files,
    new_resource.path
  )
  files.sort_by! { |path| path.count(::File::SEPARATOR) }

  files.each do |path|
    next unless ::File.fnmatch(new_resource.pattern, path, ::File::FNM_EXTGLOB)
    full_path = ::File.join(new_resource.path, path)
    # noinspection RubyResolve
    delegate = elasticsearch_bulk_cookbook_file full_path do
      path full_path
      index new_resource.index
      type new_resource.type
    end
    copy_common_attributes(delegate)
  end
end
