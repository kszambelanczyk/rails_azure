# frozen_string_literal: true

module Azure
  class TranscriptJob < VideoJob

    private

    WAV_EXTENSION = 'wav'

    def perform_job()
      puts("performing Azure transcript job")

      # @video.speech.get_transcript!

      # FIXME: Hardcoded video url
      video_url = "https://sparksolutiontest.s3.eu-central-1.amazonaws.com/out_short.mov"
      wav_tempfile = Videos::AzureAudioExtractor.new(video_url: video_url).call.value!

      # upload_filename = "#{@video.filename_from_url}.#{WAV_EXTENSION}"
      # FIXME: Uploader using hardcoded file name
      file_uri = Aws::S3Uploader.call(tempfile: wav_tempfile, upload_filename: "test_name.wav").value!

      # TODO: I think we can use google cloud for audio storage as a replacement for above
      # and use the two lines below
      # ::Google::Uploader.new(upload_filename, flac_tempfile).call
      # gcs_uri = "gs://#{ENV['GOOGLE_STORAGE_BUCKET']}/uploads/#{upload_filename}"

      # FIXME: Hard coded audio file uri 
      # file_uri = "https://sparksolutiontest.s3.eu-central-1.amazonaws.com/out_short.wav"
      # file_uri = "https://sparksolutiontest.s3.eu-central-1.amazonaws.com/output.mp3"
      # file_uri = "https://sparksolutiontest.s3.eu-central-1.amazonaws.com/broken_output.mp3"

      # video.wait_transcript!

      transcript = ::Azure::SpeechToText.call(transcript: {language: "fr-FR"}, uri: file_uri).value!

      # @video.subtitle_transcript.update!(plain_text: transcript)
      # @video.speech.update!(transcript_id: GOOGLE_TRANSCRIPTION_MARK, transcript: transcript)
      
      # @video.speech.finish_transcript!
      # @video.finish!
    ensure
      wav_tempfile&.close
    end

  end
end