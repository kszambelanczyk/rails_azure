# frozen_string_literal: true

module Videos
  class ExtractAudioForAzure

    def initialize(video_id) 
      # @video = Video.find(video_id)
      # @video_url = @video.uploaded_file&.url || @video.url

      # FIXME: Hardcoded video_url, not needed in this implementation right now
      @video_url = "https://sparksolutiontest.s3.eu-central-1.amazonaws.com/video.mov"
    end
    
    def call
      extract
    end
    
    private
    
    WAV_EXTENSION = '.wav'

    # If the name of the tempfile is too long,
    # then "Errno::ENAMETOOLONG (File name too long @ rb_sysopen)" could be raised.
    MAXIMUM_FILENAME_LENGTH = 160
    
    def extract
      wav_tempfile = Tempfile.new([filename, WAV_EXTENSION]) 
      
      # FIXME: getting file from local disk
      File.open("out_cut.wav", "r") {|f|
        wav_tempfile.write f.read
      }
      wav_tempfile.rewind

      
      wav_tempfile
    end

    def filename
      @video_url.split('/')[-1].split('.')[0][0..MAXIMUM_FILENAME_LENGTH].delete("()'")
    end
  end
end