# frozen_string_literal: true

module LookAroundHelper
  TERRAIN_TYPES = %w[roadmap satellite hybrid terrain].freeze

  def map_terrain_types_options
    options_for_select(TERRAIN_TYPES.map { |t| [t('look_around.terrain_type', name: t.capitalize), t] })
  end

  def saved_shapes_options
    return '' unless current_user

    current_user.shapes.map { |shape| shape_option(shape) }.join
  end

  def shape_option(shape)
    content_tag(:option, shape.name, value: shape.points.to_json, 'data-shape-type': shape.shape_type.capitalize,
                                     'data-shape-id': shape.id, 'data-shape-radius': shape.radius)
  end

  def user_role(user)
    user.agent? ? 'Agent' : 'Buyer'
  end

  def can_user_share_property_through_modal?(flagged_properties_ids, property_id)
    user_accept_notification_type?('share_house_modal_in_app') && !flagged_properties_ids.include?(property_id)
  end

  def can_user_see_slider_options?(user)
    !user_signed_in? || user.co_borrower?
  end

  def property_card_action(user, flagged_properties_ids, property_id)
    if user&.agent?
      flagged_properties_ids.include?(property_id) ? t('look_around.featured.home.saved') : t('look_around.featured.home.save_and_share')
    elsif flagged_properties_ids.include?(property_id)
      t('look_around.featured.home.flagged')
    else
      user_signed_in? && user_accept_notification_type?('share_house_modal_in_app') ? t('look_around.featured.home.flag_and_share') : t('look_around.featured.home.flag_home')
    end
  end

  def look_around_title
    if params[:my_flagged_homes]
      current_user.agent? ? t('look_around.search.featured.my_saved_homes') : t('look_around.search.featured.my_flagged_homes')
    else
      t('look_around.featured.featured')
    end
  end

  def most_watched?(area, listing_id)
    most_watched_properties_ids(area).include?(listing_id)
  end

  def most_watched_properties_ids(area)
    @most_watched_properties_ids ||= FindMostWatchedPropertiesService.new(area, 10, 2.weeks.ago).properties_ids
  end

  def price_status(actual_price, property_id)
    property = PropertyPrice.find_or_create_by(property_id: property_id)

    if property.price
      if property.price < actual_price
        :increased
      elsif property.price > actual_price
        :decreased
      end
    else
      property.update(price: actual_price)

      nil
    end
  end
end
