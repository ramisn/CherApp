# frozen_string_literal: true

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects no professional when accessing to pricing' do
    get '/pricing'

    assert_redirected_to root_path
    assert 'You can not access to this section', flash[:alert]
  end

  test 'it renders pricing page if professional' do
    login_as users(:agent_user)
    get '/pricing'

    assert_template :pricing
  end

  test 'it renders investors page' do
    get '/investors'

    assert_template :investors
  end

  test 'it renders know more page' do
    get '/know_more'

    assert_template :know_more
  end

  test 'it renders not found page' do
    get '/not_found'

    assert_template :not_found
  end

  test 'it renders partner with us page' do
    get '/partner_with_us'

    assert_template :partner_with_us
  end

  test 'it renders privacy page' do
    get '/privacy'

    assert_template :privacy
  end

  test 'it renders referal agreement page' do
    get '/referal_agreement'

    assert_template :referal_agreement
  end

  test 'it renders termns  page' do
    get '/terms'

    assert_template :terms
  end

  test 'it renders who we are  page' do
    get '/who_we_are'

    assert_template :who_we_are
  end

  test 'it renders about  page' do
    get '/about'

    assert_template :about
  end
end
