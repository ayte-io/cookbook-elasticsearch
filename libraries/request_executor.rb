# frozen_string_literal: true

require 'json'

require_relative 'response'

module Ayte
  module Chef
    module Cookbook
      module ElasticSearch
        class RequestExecutor
          def self.execute(request)
            require 'rest-client'
            request = normalize_request(request.copy)

            begin
              response = ::RestClient::Request.execute(
                method: request.method,
                url: create_url(request),
                params: ::RestClient::ParamsArray.new(request.parameters),
                headers: request.headers,
                payload: request.body,
                timeout: request.timeout
              )
            rescue ::RestClient::ExceptionWithResponse => e
              response = e.response
            end
            convert_response(response, request)
          end

          def self.convert_response(response, request)
            result = Response.new
            if response.body&.length&.positive?
              result.body = ::JSON.parse(response.body)
            end
            result.code = response.code
            result.headers = response.headers
            result.request = request
            result
          end

          def self.apply_authorization(request)
            authorization = request.authorization
            return request unless authorization
            if authorization.respond_to?(:apply)
              authorization.apply(request)
            else
              headers = request.headers
              headers['Authorization'] = authorization.to_s
              request.headers = headers
            end
            request
          end

          def self.normalize_request(request)
            request.method = request.method.to_s.downcase.to_sym
            headers = request.headers
            unless headers.include?('Content-Type')
              headers['Content-Type'] = 'application/json'
            end
            request.headers = headers
            body = request.body
            unless body.nil? || body.is_a?(String) || body.respond_to?(:read)
              request.body = ::JSON.dump(body)
            end
            request = apply_authorization(request)
            request
          end

          def self.create_url(request)
            schema = request.tls ? 'https' : 'http'
            host = request.host || 'localhost'
            port = request.port || 9200
            path = request.path ? request.path.gsub(%r{^/+}, '') : ''
            "#{schema}://#{host}:#{port}/#{path}"
          end
        end
      end
    end
  end
end
