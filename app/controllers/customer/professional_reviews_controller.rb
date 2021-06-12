# frozen_string_literal: true

module Customer
  class ProfessionalReviewsController < AuthenticationsController
    before_action :find_customer

    def create
      review = @customer.professional_reviews.build(review_params)
      if users_can_receive_review? && review.save
        flash[:notice] = t('flashes.reviews.create.notice')
      else
        flash[:alert] = t('flashes.reviews.create.alert')
      end
      redirect_back fallback_location: root_path
    end

    def update
      review = @customer.professional_reviews.find(params[:id])
      if review.update(review_params)
        flash[:notice] = t('flashes.reviews.update.notice')
      else
        flash[:alert] = t('flashes.reviews.update.alert')
      end
      redirect_back fallback_location: root_path
    end

    private

    def users_can_receive_review?
      @customer.agent?
    end

    def find_customer
      @customer = User.find(review_params[:reviewed_id])
    end

    def review_params
      params.require(:professional_review)
            .permit(:reviewed_id,
                    :comment,
                    :title,
                    :local_knowledge,
                    :process_expertise,
                    :responsiveness,
                    :negotiation_skills)
            .merge(reviewer: current_user)
    end
  end
end
