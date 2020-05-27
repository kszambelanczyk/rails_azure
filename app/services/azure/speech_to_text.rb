module Azure
  class SpeechToText < ApplicationService

    class TranscriptionFailed < StandardError; end

    option :transcript
    option :uri

    permissible_errors [] # TranscriptionFailed, Faraday::ConnectionFailed, Faraday::TimeoutError
    
    Schema = Dry::Schema.Params do
      required(:transcript).hash do 
        required(:language).filled(:string)
      end
      required(:uri).filled 
    end

    def call
      convert_speech_to_text
    end

    private

    AZURE_STATUS_POLLING_DELAY = 5

    def convert_speech_to_text
      payload = {
        Name: "Name",
        Description: "Description",
        Locale: transcript[:language],
        RecordingsUrl: uri,
        Properties: {
          PunctuationMode: "DictatedAndAutomatic",
          ProfanityFilterMode: "None",
          AddWordLevelTimestamps: "True"
        },
        Models: []      
      }
      json_payload = payload.to_json
  
      headers = {
        "Content-Type": "application/json",
        "Content-Length": "#{json_payload.length}",
        "Ocp-Apim-Subscription-Key": "#{Rails.application.credentials.azure_speech[:key]}"
      }
      url = "https://#{Rails.application.credentials.azure_speech[:region]}.cris.ai:443/api/speechtotext/v2.0/Transcriptions/"
      resp = Faraday.post(url, json_payload, headers)
      
      unless resp.status==202
        raise StandardError.new "New transcription request failed"
      end

      results = check_azure_speech_status(resp.headers[:location])

      # TODO: Extract needed results data
      Success.new(results)
    end

    def check_azure_speech_status(location_url)
      headers = {
        "Ocp-Apim-Subscription-Key": "#{Rails.application.credentials.azure_speech[:key]}"
      }
      resp = Faraday.get(location_url, nil, headers)

      unless resp.status==200
        raise StandardError.new "Check transcription status request failed"
      else
        data = JSON.parse(resp.body)

        case data["status"]
        when "Succeeded"
          # transcription succedded
          return get_azure_speech_results(data["resultsUrls"]["channel_0"])
        when "Failed"
          # transcription failed
          raise TranscriptionFailed.new data["statusMessage"]
        when "NotStarted"
          # transcription not started yet
          puts "Not started"
        when "Running"
          # transcription still running
          puts "Is running"
        end

        sleep AZURE_STATUS_POLLING_DELAY 
        return check_azure_speech_status(location_url)
      end
    end

    def get_azure_speech_results(results_url)
      headers = {
        "Ocp-Apim-Subscription-Key": "#{Rails.application.credentials.azure_speech[:key]}"
      }
      resp = Faraday.get(results_url, nil, headers)

      # path to words data: JSON.parse(resp.body)["AudioFileResults"][0]["SegmentResults"][0]["NBest"][0]["Words"]

      JSON.parse(resp.body)
    end

  end
end