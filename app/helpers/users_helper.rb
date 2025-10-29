module UsersHelper
  def user_name_tag(user)
    if user.deleted?
      content_tag(:span, user.display_name, class: 'text-gray-400')
    else
      user.display_name
    end
  end
end
