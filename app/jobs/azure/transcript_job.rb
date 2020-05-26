# frozen_string_literal: true

module Azure
  class TranscriptJob < VideoJob

    private

    WAV_EXTENSION = 'wav'

    def perform_job()
      puts("performing Azure transcript job")

      # @video.speech.get_transcript!

      # get wav 16 bit 16kHz mono
      wav_tempfile = Videos::ExtractAudioForAzure.new(@video[:id]).call
      # upload_filename = "#{@video.filename_from_url}.#{FLAC_EXTENSION}"
      # ::Google::Uploader.new(upload_filename, flac_tempfile).call
      # gcs_uri = "gs://#{ENV['GOOGLE_STORAGE_BUCKET']}/uploads/#{upload_filename}"

      # FIXME: Hard coded audio file uri 
      file_uri = "https://sparksolutiontest.s3.eu-central-1.amazonaws.com/out_short.wav"
      # file_uri = "https://sparksolutiontest.s3.eu-central-1.amazonaws.com/output.mp3"
      # file_uri = "https://sparksolutiontest.s3.eu-central-1.amazonaws.com/broken_output.mp3"

      # video.wait_transcript!

      transcript = ::Azure::SpeechToText.call(transcript: {language: "fr-FR"}, uri: file_uri)
      # transcript = ::Google::SpeechToText.new(flac_tempfile, @video.subtitle_transcript, gcs_uri).call
      # @video.subtitle_transcript.update!(plain_text: transcript)
      # @video.speech.update!(transcript_id: GOOGLE_TRANSCRIPTION_MARK, transcript: transcript)
      
      # @video.speech.finish_transcript!
      # @video.finish!
    ensure
      wav_tempfile&.close
    end

  end
end