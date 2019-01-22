# frozen_string_literal: true

module Ayte
  module Chef
    module Cookbook
      module ElasticSearch
        class Response
          attr_accessor :code
          attr_accessor :body
          attr_accessor :headers
          attr_accessor :request

          def errors?
            body&.fetch('errors', false)
          end

          def to_s
            "#{code}: #{body}\nRequest: #{request}"
          end
        end
      end
    end
  end
end
