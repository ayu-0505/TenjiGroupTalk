module LoginSupport
  def log_in_as(user)
    click_link 'ログアウト' if page.has_link?('ログアウト')
    google_mock(user)
    visit root_path
    click_on 'Googleでログイン', match: :first
    expect(page).to have_text('ダッシュボード')
  end

  def google_mock(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] =
      OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: user.uid,
        info: {
          name: user.name,
          email: user.email,
          image: user.image
        }
      })
  end

  def sign_in(user)
    mock_session = ActionController::TestSession.new(user_id: user.id)
    # NOTE: request specにてlog_in_as()によるsession関係が機能しないため、非推奨メソッドを一時許可
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(mock_session) # rubocop:disable RSpec/AnyInstance
  end
end
