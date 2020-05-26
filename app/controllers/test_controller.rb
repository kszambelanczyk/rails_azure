class TestController < ApplicationController

  def test
    Azure::TranscriptJob.perform_later(1, { locale: "fr-FR" })

    render plain: "Testing Azure speech"
  end
 
end
