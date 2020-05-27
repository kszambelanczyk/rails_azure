# frozen_string_literal: true

module Aws
  class S3Uploader < ApplicationService

    option :upload_filename
    option :tempfile

    permissible_errors []
    
    Schema = Dry::Schema.Params do
      required(:upload_filename).filled 
      required(:tempfile).filled 
    end

    def call
      upload
    end

    private

    AUDIO_EXTENSION = '.wav'

    def upload

      # TODO: update uploaded file target folder on bucket
      obj = AMAZON_S3_CLIENT.bucket(Rails.application.credentials.aws[:bucket]).object("#{Time.now}/#{upload_filename}")
      obj.upload_file(tempfile.path)

      # TODO: Should we use public url here, maybe presigned url, or maybe return something else
      Success.new(obj.presigned_url(:get, expires_in: 3600))
    end

  end
end
