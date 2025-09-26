module UsersHelper
  def display_user_name(user)
    if user.deleted?
      content_tag(:span, user.nickname, class: 'text-gray-400')
    else
      user.nickname
    end
  end
end
