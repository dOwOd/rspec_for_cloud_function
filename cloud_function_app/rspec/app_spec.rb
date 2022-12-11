require 'rspec'
require 'functions_framework/testing'
require 'aws-sdk-firehose'

describe 'CloudFunction' do
  include FunctionsFramework::Testing

  let(:event) { FunctionsFramework::Testing.make_cloud_event({ 'any_datas' => ['hoge'] }) }
  let(:firehose_client) { double('firehose_client double') }
  let(:file_path) { File.join __dir__, '../app.rb' }
  let(:resp) { double('resp double') }
  before do
    allow(Aws::Firehose::Client).to receive(:new).and_return(firehose_client)
    allow(firehose_client).to receive(:put_record_batch).and_return(resp)
    allow(resp).to receive(:failed_put_count).and_return(0)
  end

  context 'When data exists' do
    it 'function is called' do
      FunctionsFramework::Testing.load_temporary file_path do
        FunctionsFramework::Testing.call_event('function', event)
        expect(firehose_client).to have_received(:put_record_batch).once
      end
    end
  end

  context 'When data does not exist' do
    let(:event) { FunctionsFramework::Testing.make_cloud_event({ 'any_datas' => [nil] }) }

    it 'function is not called' do
      FunctionsFramework::Testing.load_temporary file_path do
        FunctionsFramework::Testing.call_event('function', event)
        expect(firehose_client).not_to have_received(:put_record_batch)
      end
    end
  end
end