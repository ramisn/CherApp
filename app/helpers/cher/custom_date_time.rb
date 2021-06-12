# frozen_string_literal: true

module Cher
  class CustomDateTime < ActionView::Helpers::DateTimeSelector
    AMPM_TRANSLATION = Hash[
        [[0, '12 AM'], [1, '1 AM'], [2, '2 AM'], [3, '3 AM'],
         [4, '4 AM'], [5, '5 AM'], [6, '6 AM'], [7, '7 AM'],
         [8, '8 AM'], [9, '9 AM'], [10, '10 AM'], [11, '11 AM'],
         [12, '12 PM'], [13, '1 PM'], [14, '2 PM'], [15, '3 PM'],
         [16, '4 PM'], [17, '5 PM'], [18, '6 PM'], [19, '7 PM'],
         [20, '8 PM'], [21, '9 PM'], [22, '10 PM'], [23, '11 PM']]
      ].freeze

    def build_options(selected, options = {})
      options = { leading_zeros: true }.merge!(options)
      start = options.delete(:start) || 0
      stop = options.delete(:end) || 59
      step = options.delete(:step) || 1
      leading_zeros = options.delete(:leading_zeros)
      select_options = []
      start.step(stop, step) do |i|
        value = leading_zeros ? format('%<value>02d', value: i) : i
        tag_options = { value: value }
        tag_options[:selected] = 'selected' if selected == i
        text = AMPM_TRANSLATION[i]
        select_options << content_tag('option', text, tag_options)
      end
      (select_options.join("\n") + "\n").html_safe
    end
  end
end
