# frozen_string_literal: true

module Users
  class ConversationsController < AuthenticationsController
    before_action :serialize_user

    def index
      @friends = ActiveModelSerializers::SerializableResource.new(current_user.friends,
                                                                  each_serializer: UsersSerializer,
                                                                  scope: current_user).as_json
    end

    # rubocop:disable Metrics/AbcSize
    def show
      user = User.find_by(slug: params[:id])
      if user
        @response = FetchMessageChannelService.new(current_user, user).execute

        return redirect_to(customer_dashboard_path, alert: @response.message) unless @response.success?

        @conversation_id = @response.channel.sid
      else
        @conversation_id = params[:id]
      end

      respond_to do |format|
        format.json { render json: @response.to_json }
        format.html do
          render 'shared/conversations/not_found' unless TwilioChatUtils.channel_exists?(@conversation_id)
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    def new
      @friends = ActiveModelSerializers::SerializableResource.new(current_user.friends,
                                                                  each_serializer: UsersSerializer,
                                                                  scope: current_user).as_json
    end

    private

    def serialize_user
      @user_serialized = UsersSerializer.new(current_user, scope: current_user).as_json
    end
  end
end
