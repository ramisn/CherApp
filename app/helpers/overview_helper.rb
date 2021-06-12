# frozen_string_literal: true

module OverviewHelper
  def exemption_type(data)
    types = data.select do |key, value|
      key if value == 'Y'
    end
    result_types = types.keys.join(', ')
    result_types.blank? ? 'Not Provided' : result_types
  end

  def tax_owner(owner)
    owner.blank? ? 'Not Provided' : "#{owner['firstNameAndMi']} #{owner['lastName']}".strip
  end

  def lender_name(lender)
    return 'Not Provided' if lender.blank?

    first_name = lender.dig('lenderFirstName')
    last_name = lender.dig('lenderLastName')
    first_name || last_name ? "#{first_name} #{last_name}".strip : 'Not Provided'
  end

  def number_to_currency_from_data(data)
    data ? number_to_currency(data, precision: 0) : 'Not Provided'
  end

  def field_data(data)
    data || 'Not Provided'
  end

  def size_area(data)
    data ? "#{data} sqft" : 'Not Provided'
  end

  def exist_data?(data)
    preforeclosure = [data.dig('borrowerNameOwner'),
                      data.dig('defaultAmount'),
                      data.dig('foreclosureRecordingDate'),
                      data.dig('judgmentAmount'),
                      data.dig('lenderNameFullStandardized'),
                      data.dig('loanBalance')]

    !preforeclosure.include?(nil)
  end

  def preforeclosure_details_is_empty?(data)
    data.none? { |d| exist_data?(d) }
  end

  def date(data)
    return 'Not Provided' unless data

    date = DateTime.parse(data)
    l(date, format: :assessment)
  end

  def percentage(data)
    data ? number_to_percentage(data, precision: 0) : 'Not Provided'
  end

  def property_utilities(data)
    data ? data.gsub(',', ', ') : 'Not Provided'
  end
end
