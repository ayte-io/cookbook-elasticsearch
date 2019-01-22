# frozen_string_literal: true

resource_name :elasticsearch_bulk_directory

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: 32)

attribute :path, name_attribute: true
attribute :pattern, [String, Symbol], default: '**/*.{json,jsons}'
attribute :index, [String, Symbol, NilClass]
attribute :type, [String, Symbol, NilClass]

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods
end

action :execute do
  # noinspection RubyResolve
  ruby_block "elasticsearch_bulk_directory:#{new_resource.name}" do
    block do
      ::Dir.glob(::File.join(new_resource.path, new_resource.pattern)) do |path|
        resource_name = "#{target_name}:#{path}"
        # noinspection RubyResolve
        target = elasticsearch_bulk_file resource_name do
          path path
          index new_resource.index
          type new_resource.type
        end
        copy_common_attributes(target)
      end
    end
  end
end
