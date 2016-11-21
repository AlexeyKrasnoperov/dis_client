RSpec.describe DistribusionClient::Adapters::Sniffers do
  context '#routes' do
    it 'downloads, parses data and returns 5 routes' do
      VCR.use_cassette('sniffers_request') do
        expect(subject.routes.count).to be == 5
        expect(subject.routes.all? { |route| route.is_a?(DistribusionClient::Route) }).to be_truthy
      end
    end
  end
end
