# frozen_string_literal: true

require 'application_system_test_case'

class ProfileTest < ApplicationSystemTestCase
  setup do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    agent = users(:agent_user)
    login_as agent
    visit edit_profile_path(agent)
  end

  test 'it can edit its info' do
    fill_in 'First name', with: 'Mike'
    fill_in 'Last name', with: 'Equihua'
    click_button 'Save'

    assert page.has_content?('User data successfully updated')
  end

  test 'it can define its number license' do
    fill_in 'user[number_license]', with: '12345678'
    click_button 'Save'

    assert page.has_content?('User data successfully updated')
  end

  test 'professional can define its role if he/she has no one' do
    fill_in 'user[number_license]', with: '12345678'
    select 'Estate Agent', from: 'Professional role'

    click_button 'Save'

    assert page.has_content?('User data successfully updated')
  end
end
