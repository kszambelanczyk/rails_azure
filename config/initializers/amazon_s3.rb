AMAZON_S3_CLIENT = Aws::S3::Resource.new(
  region: Rails.application.credentials.aws[:region],
  access_key_id: Rails.application.credentials.aws[:access_key_id],
  secret_access_key: Rails.application.credentials.aws[:secret_access_key]
)