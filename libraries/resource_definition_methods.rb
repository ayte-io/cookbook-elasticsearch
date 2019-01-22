# frozen_string_literal: true

module Ayte
  module Chef
    module Cookbook
      module ElasticSearch
        # Module for common methods that should be called during
        # resource definition process
        module ResourceDefinitionMethods
          def define_common_attributes(timeout: 8)
            # Cluster name, does nothing besides user-friendly resource naming
            attribute :cluster, [String, Symbol, NilClass]

            attribute :host, String, default: 'localhost'
            attribute :port, Integer, default: 9200
            attribute :tls, [TrueClass, FalseClass]

            attribute :user, [String, Symbol, NilClass]
            attribute :password, [String, Symbol, NilClass]
            attribute :authorization, [String, Symbol, NilClass]

            attribute :timeout, Integer, default: timeout
          end
        end
      end
    end
  end
end
