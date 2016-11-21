RSpec.describe DistribusionClient::Adapters::Loopholes do
  context '#routes' do
    it 'downloads, parses data and returns 4 routes' do
      VCR.use_cassette('loopholes_request') do
        expect(subject.routes.count).to be == 4
        expect(subject.routes.all? { |route| route.is_a?(DistribusionClient::Route) }).to be_truthy
      end
    end
  end
end
