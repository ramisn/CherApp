# frozen_string_literal: true

module CoBorrower
  module DashboardHelper
    PROGRESS_CLASS_STATUS = {
      active: 'is-active',
      completed: 'is-completed'
    }.freeze

    PROGRESS_CLASS_DESCRIPTION_STATUS = {
      active: 'has-text-main-body',
      completed: 'is-lighter-blue'
    }.freeze

    def create_progress_item(content, description, image_name, args = {})
      path = args[:path]
      id = args[:id]
      status = args[:status]
      contact = args[:contact]
      image_target_id = args[:image_target_id]

      content_tag :li, class: "steps-segment #{PROGRESS_CLASS_STATUS[status]}", 'data-controller': ('modal' if contact).to_s do
        concat step_marker(status)
        concat step_details(content, description, image_name, path, status: status, hidden_mobile: true, id: id, contact: contact, image_target_id: image_target_id)
        concat render('shared/contact_professional_modal') if contact
      end
    end

    def step_marker(status)
      return content_tag(:span, fa_icon('check'), class: 'steps-marker') if status == :completed

      content_tag(:span, fa_icon('ellipsis-h'), class: 'steps-marker')
    end

    def step_details(content, description, image_name, path, args = {})
      item_id = args[:id]
      status = args[:status]
      contact = args[:contact]
      image_target_id = args[:image_target_id]

      content_tag(:div) do
        concat mobile_step_detail(image_name, image_target_id)
        concat desktop_step_detail(image_name: image_name, contact: contact, content: content,
                                   status: status, item_id: item_id, path: path, description: description)
      end
    end

    def mobile_step_detail(image_name, image_target_id)
      content_tag(:div, class: 'steps-content is-hidden-tablet') do
        concat image_tag("#{image_name}.svg", class: 'is-block has-margin-auto m-t-sm is-marginless-mobile is-hidden-mobile is-clickable',
                                              'data-action': 'click->coborrower-stepper#showMobileDescription', 'data-description-id': image_target_id)
      end
    end

    def desktop_step_detail(args = {})
      image_name = args[:image_name]
      contact = args[:contact]
      content = args[:content]
      status = args[:status]
      item_id = args[:item_id]
      path = args[:path]
      description = args[:description]

      content_tag(:div, class: 'steps-content is-hidden-mobile', 'data-controller': 'collapsible') do
        concat image_link(path, item_id, image_name)
        concat step_detail_tag(contact, content, item_id, path)

        concat content_tag(:span, description, class: "is-block is-clipped is-hidden-mobile #{PROGRESS_CLASS_DESCRIPTION_STATUS[status]}", 'data-target': 'collapsible.container')
      end
    end

    def image_link(path, item_id, image_name)
      link_to(path, id: item_id) do
        image_tag("#{image_name}.svg", class: 'is-block has-margin-auto m-t-sm is-marginless-mobile is-hidden-mobile',
                                       'data-action': 'mouseover->collapsible#toogleCollapsible mouseout->collapsible#toogleCollapsible')
      end
    end

    def mobile_step_details(content, description, path, args = {})
      item_id = args[:id]
      container_id = args[:container_id]
      show = args[:show]

      content_tag(:div, class: "is-mobile is-paddingless is-marginless mobile-description #{'is-hidden' unless show}", id: container_id) do
        concat content_tag(:span, link_to(content, path, class: 'is-bold link is-size-6 m-l-md has-text-coborrower-blue', id: item_id))
        concat content_tag(:p, description, class: 'is-size-7 is-paddingless m-l-md')
      end
    end

    def user_current_step_number(user)
      steps_num = 1

      steps_num += 1 if user.flag_property_progress_status == :completed

      steps_num += 1 if user.friends_progress_status == :completed

      steps_num += 1 if user.contact_professional_progress_status == :completed && @flagged_properties.any?

      steps_num += 1 if user.zero_closing_progress_status == :completed

      steps_num
    end

    def number_of_people_who_also_flagged(property)
      FlaggedProperty.where(property_id: property['listingId']).where.not(user: current_user).count
    end

    def step_detail_tag(contact, content, item_id, path)
      if contact
        content_tag(:button, content, class: 'is-link has-text-coborrower-blue',
                                      'data-action': 'click->modal#toggleModal mouseover->collapsible#toogleCollapsible mouseout->collapsible#toogleCollapsible')
      else
        content_tag(:span, link_to(content, path, id: item_id, class: 'is-bold link is-hidden-mobile is-clickable has-text-coborrower-blue',
                                                  'data-action': 'mouseover->collapsible#toogleCollapsible mouseout->collapsible#toogleCollapsible'))
      end
    end
  end
end
