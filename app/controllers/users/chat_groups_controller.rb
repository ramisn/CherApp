# frozen_string_literal: true

module Users
  class ChatGroupsController < AuthenticationsController
    before_action :define_channel_sid, :define_member_permissions, only: %i[show edit update]
    before_action :serialize_user

    def show
      render 'shared/conversations/not_found' if chat_not_found
    end

    def new
      @flagged_properties = current_user.flagged_properties_data
      @friends = ActiveModelSerializers::SerializableResource.new(current_user.friends,
                                                                  each_serializer: UsersSerializer,
                                                                  scope: current_user).as_json
    end

    def create
      respond_to do |format|
        format.json do
          channel_sid = setup_twilio_channel
          participants = group_params[:participants]
          add_participants_to_channel(channel_sid, participants)

          GroupCreationNotifierJob.perform_later(participants, current_user, chat_group_url(channel_sid))
          # add admin user to participants
          participants.append(current_user.email)
          channel = create_message_channel(channel_sid, participants)
          render json: channel, status: 201
        end
      end
    end

    def edit
      render 'shared/conversations/not_found' unless TwilioChatUtils.channel_exists?(@channel_sid)
    end

    def update
      return redirect_to conversations_path(@channel_sid) unless @member_permissions.include?('addMember')

      respond_to do |format|
        format.json do
          update_channel_info
          render json: {}, status: 200
        end
      end
    end

    private

    def define_channel_sid
      @channel_sid = params[:id]
    end

    def define_member_permissions
      @member_permissions = TwilioChatUtils.member_permissions(@channel_sid, current_user.email)
    end

    def group_params
      params.require(:group)
            .permit(:name, :image_url, participants: [], users_to_add: [], users_to_remove: [])
    end

    def setup_twilio_channel
      twilio_channel = TwilioChatUtils.create_channel(current_user.email,
                                                      { purpose: 'chat_group' }.to_json,
                                                      friendly_name: group_params[:name])
      twilio_channel.sid
    end

    def add_participants_to_channel(twilio_channel_sid, participants)
      # setup admin user for Twilio channel
      TwilioChatUtils.join_user_to_channel(current_user.email, twilio_channel_sid, admin: true)

      # setup participants for Twilio channel
      participants.each do |email|
        TwilioChatUtils.join_user_to_channel(email, twilio_channel_sid, admin: false)
      end
    end

    def serialize_user
      @user_serialized = UsersSerializer.new(current_user, scope: current_user).as_json
    end

    def update_channel_info
      TwilioChatUtils.update_channel(@channel_sid, friendly_name: group_params[:name])
      group_params[:users_to_add].each do |user_email|
        TwilioChatUtils.join_user_to_channel(user_email, @channel_sid)
        MessageChannel.add_participant_to_channel(@channel_sid, user_email)
      end
      group_params[:users_to_remove].each do |user_email|
        TwilioChatUtils.remove_user_from_channel(user_email, @channel_sid)
        MessageChannel.remove_participant_from_channel(@channel_sid, user_email)
      end
    end

    def chat_not_found
      !TwilioChatUtils.channel_exists?(@channel_sid) || @member_permissions.blank?
    end

    def create_message_channel(channel_sid, participants)
      MessageChannel.create!(sid: channel_sid, participants: participants,
                             purpose: 'group', image_url: chat_image_url)
    end

    def chat_image_url
      group_params[:image_url] || url_for(current_user.profile_image)
    end
  end
end
