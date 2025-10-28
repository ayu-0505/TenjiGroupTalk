class CommentNotificater
  def call(_name, _started, _finished, _unique_id, payload)
    comment = payload[:comment]
    return if comment.nil?

    user = payload[:user]
    talk = payload[:talk]
    subscribers = talk.subscribers.where.not(id: user.id)
    subscribers.each do |subscriber|
      Notification.find_or_create_by!(
        user: subscriber,
        comment:
      )
    end
  end
end
