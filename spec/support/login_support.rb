module LoginSupport
  def log_in_as(user)
    OmniAuth.configure do |config|
      config.test_mode = true
      config.mock_auth[:google_oauth2] =
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

    visit root_path
    click_on 'Googleでログイン', match: :first
  end

  def sign_in(user)
    mock_session = ActionController::TestSession.new(user_id: user.id)
    # NOTE: request specにてlog_in_as()によるsession関係が機能しない。sessionはrequestの本室ではないので非推奨メソッドを一時許可
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(mock_session) # rubocop:disable RSpec/AnyInstance
  end
end
