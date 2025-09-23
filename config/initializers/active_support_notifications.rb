# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  ActiveSupport::Notifications.subscribe('talk.create', TalkSubscriber.new)
  ActiveSupport::Notifications.subscribe('comment.create', CommentSubscriber.new)
  ActiveSupport::Notifications.subscribe('comment.create', CommentNotificater.new)
end
