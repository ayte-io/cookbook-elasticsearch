# frozen_string_literal: true

module Ayte
  module Chef
    module Cookbook
      module ElasticSearch
        # Module for common action_class methods
        module ResourceMethods
          DEFAULT_ATTRIBUTES = %i[
            cluster
            host port tls
            user password authorization
            timeout
          ].freeze

          def target_name
            # noinspection RubyResolve
            new_resource.cluster || "#{new_resource.host}:#{new_resource.port}"
          end

          def to_request(type: :get, path: nil)
            request = ::Ayte::Chef::Cookbook::ElasticSearch::Request
              .from_resource(new_resource)
            request.method = type
            request.path = path unless path.nil?
            yield request if block_given?
            request
          end

          def execute_request(request)
            ::Ayte::Chef::Cookbook::ElasticSearch::RequestExecutor.execute(request)
          end

          def to_request_resource(name: nil, type: :get, path: nil, &block)
            name = "#{target_name}/#{path}" if name.nil?
            raise 'Can\'t compute resource name' if name.nil?
            # noinspection RubyResolve
            delegate = elasticsearch_request name do
              type type
              path path unless path.nil?
              instance_eval(&block) unless block.nil?
            end

            copy_common_attributes(delegate)
            delegate
          end

          def copy_common_attributes(target)
            DEFAULT_ATTRIBUTES.each do |name|
              value = new_resource.send(name)
              target.send(name, value)
            end
          end
        end
      end
    end
  end
end
