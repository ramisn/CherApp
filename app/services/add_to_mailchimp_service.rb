# frozen_string_literal: true

class AddToMailchimpService
  LIST_ID = ENV['MAILCHIMP_LIST_ID']

  def process(email, type)
    subscribing_user = {
      first_name: '',
      last_name: '',
      email: email
    }

    response = request_member_addition(subscribing_user)

    TagMailchimpJob.perform_later(email, type) if response['id']
  rescue StandardError => e
    Raven.capture_exception(e)
    false
  end

  private

  def request_member_addition(user_params)
    $mailchimp.lists.add_list_member(LIST_ID,
                                     email_address: user_params[:email],
                                     status: 'subscribed',
                                     merge_fields: {
                                       FNAME: user_params[:first_name],
                                       LNAME: user_params[:last_name]
                                     })
  end
end
