# frozen_string_literal: true

namespace :clique do
  task notify_professionals_before_end: :environment do
    date = 3.days.from_now

    professionals = User.with_clique.where('end_of_clique <= ?', date)
    professionals.each do |professional|
      last4 = FindLast4Service.new(professional).execute
      UserAccountMailer.with(user: professional, last4: last4).clique_about_to_end.deliver_later

      sms_message = I18n.t('sms_notifications.clique_expire_soon', user_name: professional.first_name,
                                                                   date: I18n.l(date, format: :month_day_year))
      SendSmsService.new(sms_message, professional.phone_number, sms_type: :clique_expiration).execute if professional.phone_number
    end
  end
end
