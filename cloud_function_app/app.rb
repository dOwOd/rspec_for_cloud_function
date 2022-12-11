require 'functions_framework'
require 'aws-sdk-firehose'

FunctionsFramework.cloud_event "function" do |event|
  any_datas = event.data['any_datas']
  firehose_client = Aws::Firehose::Client.new(
    access_key_id: 'xxxxx',
    secret_access_key: 'xxxxx',
    region: 'xxxxx'
  )

  any_datas.each do |any_data|
    next if any_data.nil?

    resp = firehose_client.put_record_batch({
      delivery_stream_name: 'xxxxx',
      records: any_data
    })
    logger.info("faild count: #{resp.failed_put_count}")
  end
end