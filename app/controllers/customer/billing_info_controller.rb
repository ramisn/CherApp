# frozen_string_literal: true

module Customer
  class BillingInfoController < BaseController
    def edit
      payment_method_id = find_customer.invoice_settings.default_payment_method
      @card = payment_method_id ? Stripe::PaymentMethod.retrieve(payment_method_id)['card'] : nil
      subscription = find_customer.subscriptions['data'].first
      @subscription_id = subscription ? subscription.id : nil
    end

    def update
      update_customer_payment_method
      flash[:notice] = t('flashes.subscriptions.update.notice')
      redirect_to customer_dashboard_path
    rescue Stripe::CardError => e
      flash.now[:alert] = e.message
      render 'edit'
    end

    def destroy
      subscriptions_id = params[:id]
      Clique::DeleteSubscriptionService.new(current_user, subscriptions_id).execute
      flash[:notice] = t('flashes.subscriptions.destroy.notice')
      redirect_to customer_dashboard_path
    end

    private

    def billing_info_params
      params.require(:billing).permit(:card_number, :expires_date, :cvc, :first_name, :last_name)
    end

    def sanitized_card_params
      date = billing_info_params.delete(:expires_date)
      exp_month, exp_year = date.match(%r{(\d\d)/(\d\d)}).captures
      { exp_month: exp_month, exp_year: exp_year, cvv: billing_info_params[:cvv], number: billing_info_params[:card_number] }
    end

    def find_customer
      @find_customer ||= begin
        customer = Stripe::Customer.list(limit: 1, email: current_user.email)['data'].first
        return customer unless customer.blank?

        Stripe::Customer.create(description: 'Clique agent', email: current_user.email, name: current_user.full_name)
      end
    end

    def update_customer_payment_method
      payment_method = Stripe::PaymentMethod.create(type: 'card', card: sanitized_card_params)
      Stripe::PaymentMethod.attach(payment_method.id, customer: find_customer.id)
      Stripe::Customer.update(find_customer.id, invoice_settings: { default_payment_method: payment_method.id })
    end
  end
end
