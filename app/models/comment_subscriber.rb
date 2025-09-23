# frozen_string_literal: true

class CommentSubscriber
  def call(_name, _started, _finished, _unique_id, payload)
    user = payload[:user]
    talk = payload[:talk]
    Subscription.find_or_create_by!(user:, talk:)
  end
end
