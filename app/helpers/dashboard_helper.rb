module DashboardHelper
  TALK_PREVIEW_LIMIT = 3

  def dashboard_talks(group)
   group.talks.order(created_at: :desc).first(TALK_PREVIEW_LIMIT)
  end
end
