require 'base64'

RSpec.describe ::Ayte::Chef::Cookbook::ElasticSearch::Request do
  def create_request
    ::Ayte::Chef::Cookbook::ElasticSearch::Request.new
  end

  describe ::Ayte::Chef::Cookbook::ElasticSearch::Request::BasicAuthorization do
    def create_auth(user, password)
      klass = ::Ayte::Chef::Cookbook::ElasticSearch::Request::BasicAuthorization
      klass.new(user, password)
    end

    context 'regular' do
      it 'creates authorization header' do
        auth = create_auth(:login, :password)
        request = create_request
        request.authorization = auth

        encoded = Base64.encode64('login:password')
        expectation = "Basic #{encoded}"

        auth.apply(request)
        expect(request.headers).to include('Authorization' => expectation)
      end
    end
  end
end
