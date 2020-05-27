# frozen_string_literal: true

module Videos
  class AzureAudioExtractor < ApplicationService

    option :video_url

    permissible_errors []
    
    Schema = Dry::Schema.Params do
      required(:video_url).filled 
    end

    def call
      extract
    end

    private

    AUDIO_EXTENSION = '.wav'

    OPTIONS = %w(-acodec pcm_s16le -ar 16000 -ac 1)

    def extract
      tempfile = Tempfile.new([filename, AUDIO_EXTENSION])

      movie = ::FFMPEG::Movie.new(@video_url)
      movie.transcode(tempfile.path, OPTIONS)

      tempfile.rewind
      Success.new(tempfile)
    end


    # If the name of the tempfile is too long,
    # then "Errno::ENAMETOOLONG (File name too long @ rb_sysopen)" could be raised.
    MAXIMUM_FILENAME_LENGTH = 160
    
    def filename
      video_url.split('/')[-1].split('.')[0][0..MAXIMUM_FILENAME_LENGTH].delete("()'")
    end

  end
end
