# frozen_string_literal: true

class KnowledgeHubController < ApplicationController
  def show
    @topics = if params[:topic]
                Topic.search_body(topic_params[:message])
              else
                Topic.find_with_index(params[:index] || '')
              end
  end

  private

  def topic_params
    params.require(:topic)
          .permit(:message)
  end
end
