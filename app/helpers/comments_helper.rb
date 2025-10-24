module CommentsHelper
  INITIAL_DISPLAY_COUNT = 5

  def exceeds_limit?(comments)
    total(comments) > INITIAL_DISPLAY_COUNT
  end

  def total(comments)
    comments.size
  end

  def display_comments(comments)
    comments.last(INITIAL_DISPLAY_COUNT)
  end

  def hidden_comments(comments)
    if exceeds_limit?(comments)
        comments.first(total(comments) - INITIAL_DISPLAY_COUNT)
    else
      []
    end
  end

  def ids(comments)
    comments.map { |comment| comment.id }
  end
end
