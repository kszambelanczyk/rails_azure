class TestController < ApplicationController

  def test
    Azure::TranscriptJob.perform_later(1)

    render plain: "Testing Azure speech"
  end
 
end
