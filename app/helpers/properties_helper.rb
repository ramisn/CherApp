# frozen_string_literal: true

module PropertiesHelper
  include OverviewHelper
  include PricesHelper

  def property_image(property)
    return 'cherapp-ownership-coborrowing-property_placeholder.png' if property.dig('photos').blank?

    property.dig('photos').first.gsub('http://', 'https://')
  end

  def anual_income_with_friends(property, persons)
    return t('generic.n_a') if property.dig('property', 'type') == 'RNT'

    constant = 0.004167
    elevation_contstant = (1 + constant)**360
    anual_income = (0.8 * property['listPrice'] * (constant * elevation_contstant / (elevation_contstant - 1))) / persons
    number_to_currency(anual_income, precision: 0)
  end

  def annual_income(property, divide = 1)
    return t('generic.n_a') if property.dig('property', 'type') == 'RNT'

    result = (((property['listPrice'] * 0.8) / 30) / 0.28) / divide
    number_to_currency(result, precision: 0)
  end

  def down_payment_with_cher(property)
    return t('generic.n_a') if property.dig('property', 'type') == 'RNT'

    number_to_currency(0, precision: 0)
  end

  def property_flag_icon(flagged_properties_ids, property_id)
    flagged_properties_ids.include?(property_id) ? 'cherapp-ownership-coborrowing-ico-favorite.svg' : 'cherapp-ownership-coborrowing-ico-favorite-white.svg'
  end

  def property_save_status(flagged_properties_ids, property_id)
    flagged_properties_ids.include?(property_id) ? t('generic.saved') : t('generic.save')
  end

  def closing_costs(property)
    return t('generic.n_a') if property.dig('property', 'type') == 'RNT'

    value1 = (property['listPrice'] * 0.2 * 0.00909)
    result = (value1 + 7_400) + value1
    number_to_currency(result, precision: 0)
  end

  def property_full_address(property_address)
    "#{property_address['streetNumber']} #{property_address['streetName']}, #{property_address['city']}, #{property_address['state']} #{property_address['postalCode']}"
  end

  def property_random_message(property_bedrooms)
    property_bedrooms ? t("property_overview.property_tiles_#{rand(1...21)}", number: property_bedrooms.round) : t('property_overview.property_tiles_default')
  end

  def property_agent_random_message(property_bedrooms)
    property_bedrooms ? t("property_overview.property_agent_tiles_#{rand(1...21)}", number: property_bedrooms.round) : t('property_overview.property_tiles_default')
  end

  def sanitize_image(image_path)
    return 'cherapp-ownership-coborrowing-property_placeholder.png' if image_path.blank?

    # For some reason properties's images from beaor vendor does not include protocole
    image_path.gsub(%r{^//}, 'https://')
  end

  def property_is_selected?(property, property_id)
    property['listingId'] == property_id ? 'is-selected' : ''
  end

  def cher_score(property)
    return '0%' if property.dig('property', 'type') == 'RNT'

    bedrooms = property.dig('property', 'bedrooms')
    return '85%' if bedrooms.blank?

    return '80%' if bedrooms > 4

    percentage = bedrooms * 20
    "#{percentage}%"
  end
end
