RSpec.describe ::Ayte::Chef::Cookbook::ElasticSearch::RequestExecutor do
  def create_request()
    ::Ayte::Chef::Cookbook::ElasticSearch::Request.new
  end

  def executor
    ::Ayte::Chef::Cookbook::ElasticSearch::RequestExecutor
  end
  describe '#normalize_request' do
    context 'regular' do
      it 'applies authorization object' do
        request = create_request
        authorization = double
        expect(authorization).to receive(:apply)
        request.authorization = authorization
        executor.normalize_request(request)
      end

      it 'applies authorization string' do
        request = create_request
        authorization = 'password hunter2'
        expect(request.headers).to eq({})
        request.authorization = authorization
        target = executor.normalize_request(request)
        expect(target.headers).to include('Authorization' => authorization)
      end

      it 'sets lowercase symbol method' do
        request = create_request
        request.method = 'ANY'
        target = executor.normalize_request(request)
        expect(target.method).to eq(:any)
      end

      it 'sets content-type header' do
        request = create_request
        expect(request.headers).to eq({})
        target = executor.normalize_request(request)
        expect(target.headers).to include('Content-Type' => 'application/json')
      end

      it 'doesn\'t override content-type header' do
        request = create_request
        type = 'application/xml'
        request.headers['Content-Type'] = type
        target = executor.normalize_request(request)
        expect(target.headers).to include('Content-Type' => type)
      end

      it 'serializes payload' do
        request = create_request
        request.body = {alpha: :beta}
        target = executor.normalize_request(request)
        expect(target.body).to eq('{"alpha":"beta"}')
      end
    end
  end
end
