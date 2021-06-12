# frozen_string_literal: true

module PropertySearchesHelper
  PROPERTIES_TYPES = {
    'residential' => 'Residential',
    'condominium' => 'Condominium',
    'mobilehome' => 'Mobile',
    'multifamily' => 'Multifamily'
  }.freeze

  def search_result_location(search_params)
    search_in = search_params[:search_in].gsub(/, .., USA/, '')
    minprice = search_params[:minprice]
    maxprice = search_params[:maxprice]
    t('look_around.search.search_in_location',
      search_type: search_type(search_params),
      location: search_in,
      minprice: formated_price(minprice.to_i),
      maxprice: formated_price(maxprice.to_i))
  end

  def search_result_amenities(search_params)
    minbeds = if search_params[:minbeds] == 'null'
                0
              else
                search_params[:minbeds] || '0'
              end
    minbaths = if search_params[:minbaths] == 'null'
                 0
               else
                 search_params[:minbaths] || '0'
               end
    t('look_around.search.search_in_amenities',
      minbeds: minbeds,
      minbaths: minbaths)
  end

  def search_type(search_params)
    if user_signed_in? && current_user.agent?
      search_params[:status] ? search_params[:status].first : search_params[:statuses].first
    else
      search_params[:type]&.first == 'rental' ? t('look_around.search.rent') : t('property_overview.coown')
    end
  end

  def property_beds(property)
    return t('property_overview.multi') if property.dig('property', 'type') == 'MLF' && property.dig('property', 'bedrooms').nil?

    beds = property.dig('property', 'bedrooms').nil? ? 0 : property.dig('property', 'bedrooms')
    t('property_overview.stats.bedrooms', count: beds)
  end

  def property_baths(property)
    return t('property_overview.multi') if property.dig('property', 'type') == 'MLF' && property.dig('property', 'bathrooms').nil?

    baths = property.dig('property', 'bathrooms').nil? ? 0 : property.dig('property', 'bathrooms')
    t('property_overview.stats.bathrooms', count: baths)
  end
end
