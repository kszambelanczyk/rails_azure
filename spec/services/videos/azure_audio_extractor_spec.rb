require "rails_helper"

module Videos

  RSpec.describe AzureAudioExtractor do
    let(:file_url) {"https://sparksolutiontest.s3.eu-central-1.amazonaws.com/out_short.mov"}

    describe "extracting audio form video for Azure speech to text" do

      it "generates Tempfile" do
        expect(AzureAudioExtractor.call(video_url: file_url).value_or(nil).instance_of?(Tempfile)).to eq true
      end

      it "generates Tempfile with extension .wav" do
        tempfile = AzureAudioExtractor.call(video_url: file_url).value_or(nil)

        expect(File.extname(tempfile.path)).to eq ".wav"
      end


      it "generates wav file bit rate: 16-bit, sample-rate: 16kHz" do
        tempfile = AzureAudioExtractor.call(video_url: file_url).value_or(nil)
        media = ::FFMPEG::Movie.new(tempfile.path)

        expect(media.metadata[:streams][0][:bits_per_sample]).to eq 16
        expect(media.metadata[:streams][0][:sample_rate]).to eq "16000"
      end

    end
  end

end