RSpec.describe DistribusionClient::Route do
  let(:source) { :sentinels }
  let(:start_node) { :alpha }
  let(:end_node) { :beta }
  let(:start_time) { Time.parse('2014-12-01T01:01:01') }
  let(:end_time) { Time.parse('2014-12-01T01:01:02') }

  subject(:route) do
    described_class.new(
      source: source,
      start_node: start_node,
      end_node: end_node,
      start_time: start_time,
      end_time: end_time
    )
  end

  context 'with nil source' do
    let(:source) { nil }

    it 'raise virtus coercion error if source nil' do
      expect { route }.to raise_error(Virtus::CoercionError,
                                      'Failed to coerce attribute `source\' from nil into String')
    end
  end

  context 'with correct time string' do
    let(:start_time) { '2014-12-01T01:01:01' }

    it 'do not raise any errors if start_time set up with correct string' do
      expect { route }.not_to raise_error
    end
  end

  context 'with incorrect time string' do
    let(:start_time) { '123' }

    it 'raise virtus coercion error if start_time set up with incorrect string' do
      expect { route }.to raise_error(Virtus::CoercionError,
                                      'Failed to coerce attribute `start_time\' from "123" into Time')
    end
  end
end
