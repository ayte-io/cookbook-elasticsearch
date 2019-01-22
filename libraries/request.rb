# frozen_string_literal: true

require 'base64'

require_relative 'request_executor'

module Ayte
  module Chef
    module Cookbook
      module ElasticSearch
        class Request
          FIELDS = {
            host: :host,
            port: :port,
            tls: :tls,
            method: :type,
            headers: :headers,
            path: :path,
            parameters: :parameters,
            body: :body,
            authorization: :authorization,
            timeout: :timeout
          }.freeze

          attr_writer :host
          attr_writer :port
          attr_writer :tls
          attr_writer :method
          attr_writer :headers
          attr_writer :path
          attr_writer :parameters
          attr_accessor :body
          attr_accessor :authorization
          attr_accessor :timeout

          def method
            @method || :get
          end

          def host
            @host || :localhost
          end

          def port
            @port || 9200
          end

          def tls
            @tls.nil? ? false : @tls
          end

          def schema
            tls ? 'https' : 'http'
          end

          def path
            (@path || '').delete_prefix('/')
          end

          def parameters
            @parameters = {} if @parameters.nil?
            @parameters
          end

          def headers
            @headers = {} if @headers.nil?
            @headers
          end

          def basic_auth(user, password)
            @authorization = BasicAuthorization.new(user, password)
          end

          def execute
            ::Ayte::Chef::Cookbook::ElasticSearch::RequestExecutor.execute(self)
          end

          def to_s
            "#{method} /#{path} #{body}"
          end

          def copy
            target = clone
            target.parameters = Request.clone_map(parameters)
            target.headers = Request.clone_map(headers)
            target.body = body&.clone
            target.authorization = target&.authorization.clone
            target
          end

          def self.clone_map(subject)
            subject ? Hash[subject.map { |k, v| [k.clone, v.clone] }] : {}
          end

          def self.from_resource(resource)
            target = Request.new
            FIELDS.each do |acceptor, provider|
              next unless resource.respond_to?(provider)
              value = resource.send(provider)
              unless value.nil? || value == false || value == true
                value = value.clone
              end
              target.send("#{acceptor}=", value)
            end
            target
          end

          class BasicAuthorization
            attr_reader :user
            attr_reader :password

            def initialize(user, password)
              @user = user
              @password = password
            end

            def apply(request)
              target = request.headers
              encoded = Base64.encode64("#{user}:#{password}")
              target['Authorization'] = "Basic #{encoded}"
              request.headers = target
            end
          end

          class HeadersAuthorization
            attr_reader :headers

            def initialize(headers)
              @headers = headers
            end

            def apply(request)
              target = request.headers
              target.update(headers)
              request.headers = target
            end
          end
        end
      end
    end
  end
end
