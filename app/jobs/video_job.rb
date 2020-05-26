# frozen_string_literal: true

class VideoJob < ApplicationJob

  queue_as :default

  attr_accessor :video, :params

  def perform(video_id, params={})
    # @video = Video.find_by id: video_id
    
    # FIXME: Hard coded video object
    @video = { 
      id: video_id,
      filename_from_url: "video.mov"
    }

    @params = params
    perform_job if @video
  end

  protected

  # To be overidden by inheriting classes
  def perform_job
    nil
  end

  # To be overidden by inheriting classes
  def service
    nil
  end

end
