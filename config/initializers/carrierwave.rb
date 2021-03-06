CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['aws_access_key_id'],
    :aws_secret_access_key  => ENV['aws_secret_access_key'],
  }
  config.storage = :fog
  config.fog_directory  = ENV['aws_bucket_name']
  config.fog_attributes = {'Cache-Control'=>'max-age=2592000'}
end