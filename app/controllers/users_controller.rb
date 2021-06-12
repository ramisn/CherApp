# frozen_string_literal: true

class UsersController < AuthenticationsController
  before_action :find_user, only: %i[show update]
  skip_before_action :authenticate_user!, only: %i[show index]

  def index
    @users = UsersFinderService.new(search_user_params, current_user).execute
    respond_to do |format|
      format.json do
        if search_user_params[:suggestion]
          render json: @users
        else
          render json: @users, each_serializer: UsersSerializer
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.html do
        return redirect_to root_path unless valid_user_identity?

        instantiate_feedback_variables
        @user_data = build_user_data
        @posts = FindFriendLastNewsfeedPosts.new(@user).execute
      end
      format.json do
        render(json: UsersSerializer.new(@user, scope: current_user).as_json) && return if @user
        render json: {}, status: 404
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def update
    return redirect_to(root_path, alert: 'Forbidden', status: 403) unless user_can_be_updated?

    if @user.update(user_params)
      respond_to do |format|
        format.html do
          flash[:notice] = t('flashes.user.update.notice')
          redirect_to co_borrower_dashboard_path
        end
        format.json do
          render(json: UsersSerializer.new(@user, scope: current_user).as_json) && return if @user
        end
      end
    else
      flash[:alert] = t('flashes.user.update.alert')
      redirect_back fallback_location: co_borrower_dashboard_path
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def instantiate_feedback_variables
    @review = ProfessionalReview.new
    @publication = Publication.new
    @comment = Comment.new
  end

  def valid_user_identity?
    @user.co_borrower? || @user.agent?
  end

  def build_user_data
    {
      user_json: UsersSerializer.new(@user, scope: current_user).as_json,
      mutual_friends: current_user.friends & @user.friends,
      properties: @user.flagged_properties_data
    }
    # TODO: get mutual friends with one query
  end

  def find_user
    @user = if params[:email]
              User.kept.find_by!(email: params[:email])
            else
              User.kept.find_by(slug: params[:id]) || User.kept.find_by!(id: params[:id])
            end
  rescue ActiveRecord::RecordNotFound
    render 'pages/not_found.html', status: 404
  end

  def search_user_params
    params.require(:user)
          .permit(:identifier,
                  :verified,
                  :personality_test,
                  :background_check,
                  :limit,
                  :suggestion,
                  :exclude_current,
                  professional_role: [])
  end

  def user_params
    params.require(:user)
          .permit(:track_share_a_sale, :skip_onbording, :city)
  end

  def user_can_be_updated?
    @user == current_user
  end
end
