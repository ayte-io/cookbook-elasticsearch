# frozen_string_literal: true

resource_name :elasticsearch_status_wait

STATUS_VARIANTS = [:green, 'green', :yellow, 'yellow'].freeze

self.class.include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceDefinitionMethods

define_common_attributes(timeout: 32)

attribute :status, [String, Symbol],
  equal_to: STATUS_VARIANTS,
  name_attribute: true

action_class do
  include ::Ayte::Chef::Cookbook::ElasticSearch::ResourceMethods
end

action :execute do
  to_request_resource(path: '_cluster/state') do
    parameters(
      wait_for_status: new_resource.status,
      timeout: 1
    )

    # noinspection RubyResolve
    retry_delay 1
    # noinspection RubyResolve
    retries new_resource.timeout
  end
end
