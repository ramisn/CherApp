# frozen_string_literal: true

module Admin
  class TopicsController < BaseController
    def index
      @topics = Topic.all
    end

    def new
      @topic = Topic.new
    end

    def create
      @topic = Topic.create(topic_params)
      if @topic.save
        flash[:notice] = t('flashes.topic.create.success')
      else
        flash[:alert] = t('flashes.topic.create.alert')
      end
      redirect_to admin_topics_path
    end

    def edit
      @topic = Topic.find(params[:id])
    end

    def destroy
      topic = Topic.find(params[:id])
      if topic.destroy
        flash[:notice] = t('flashes.topic.destroy.success')
      else
        flash[:alert] = t('flashes.topic.destroy.alert')
      end
      redirect_to admin_topics_path
    end

    def update
      @topic = Topic.find(params[:id])
      if @topic.update(topic_params)
        flash[:notice] = t('flashes.topic.update.success')
        redirect_to admin_topics_path
      else
        flash[:notice] = t('flashes.topic.update.alert')
        render 'edit'
      end
    end

    private

    def topic_params
      params.require(:topic).permit(:name, :rich_body)
    end
  end
end
