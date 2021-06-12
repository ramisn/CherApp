# frozen_string_literal: true

require 'application_system_test_case'

class LookAroundTest < ApplicationSystemTestCase
  setup do
    WebStub.stub_redis_properties
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
  end

  test 'user can access to look around page' do
    visit look_around_path

    assert_content 'Location'
  end

  test 'user can search homes by city' do
    visit look_around_path

    page.execute_script("document.getElementById('searchFor').setAttribute('value', 'Santa Monica');")
    click_button 'Search'

    assert_content 'Search result'
  end

  test 'user can search homes by price range ' do
    visit look_around_path

    page.execute_script("document.getElementById('searchFor').setAttribute('value', 'Santa Monica');")
    find('.button', text: 'Budget').hover
    select '$125K', from: 'search[minprice]'
    select '$1M', from: 'search[maxprice]'
    click_button 'Done'

    assert_content 'Search result'
  end

  test 'user can search homes by number of beds/baths' do
    visit look_around_path

    page.execute_script("document.getElementById('searchFor').setAttribute('value', 'Santa Monica');")
    find('.button', text: 'Any BD, Any BA').hover
    choose '1+', id: 'search_min_beds_1', allow_label_click: true
    choose '4+', id: 'search_min_baths_4', allow_label_click: true
    click_button 'Done'

    assert_content 'Search result'
  end

  test 'user can filter by home type' do
    visit look_around_path

    page.execute_script("document.getElementById('searchFor').setAttribute('value', 'Santa Monica');")
    find('.button', text: 'Home type').hover
    check 'Condo', allow_label_click: true
    check 'Multifamily', allow_label_click: true
    click_button 'Done'

    assert_content 'Search result'
  end

  test 'user can search homes by extra filtering params' do
    visit look_around_path

    page.execute_script("document.getElementById('searchFor').setAttribute('value', 'Santa Monica');")
    find('.button', text: 'More').hover
    fill_in 'Square Feet', with: 120
    fill_in 'search_maxarea', with: 500
    fill_in 'Year Built', with: 1990
    fill_in 'search_maxyear', with: 2010
    fill_in 'Keywords', with: 'fireplace'
    click_button 'Done'

    assert_content 'Search result'
  end

  test 'agent can search by my areas selector' do
    login_as users(:clique_agent)
    visit look_around_path

    select 'Santa Monica', from: 'search_in'

    assert_content 'Search result', wait: 5
  end

  test 'user can switch between types of prices' do
    login_as users(:clique_agent)
    visit look_around_path

    page.execute_script("document.getElementById('searchFor').setAttribute('value', 'Santa Monica');")
    find('.button', text: 'Budget').hover
    page.execute_script("document.querySelectorAll('[for=switchBudget]')[0].click();")
    select '$5000', from: 'search[maxprice]'
    click_button 'Done'

    assert_content 'Search result'
  end

  test 'user can see price changes in properties' do
    visit look_around_path

    page.execute_script("document.getElementById('searchFor').setAttribute('value', 'Santa Monica');")
    click_button 'Search'

    assert_content 'Search result'
    assert find(:xpath, '//*[@id="property94106826"]/div/img')
  end
end
