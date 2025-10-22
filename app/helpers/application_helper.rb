module ApplicationHelper
  def turbo_stream_flash
    turbo_stream.update 'flash', partial: 'layouts/flash'
  end

  def pagination_page_class(is_current_page:, is_last_page:)
    return unless is_current_page

    css_classes = [ 'current', 'block', 'rounded-md', 'rounded-r-none', 'rounded-l-none', 'border', 'border-slate-300', 'py-2', 'px-3',
      'text-center', 'text-sm', 'transition-all', 'shadow-sm', 'hover:shadow-lg', 'text-slate-600', 'hover:text-white', 'hover:bg-slate-800',
      'hover:border-slate-800', 'focus:text-white', 'focus:bg-slate-800', 'focus:border-slate-800', 'active:border-slate-800', 'bg-teal-300',
      'active:text-white', 'active:bg-slate-800', 'disabled:pointer-events-none', 'disabled:opacity-50', 'disabled:shadow-none' ]

    css_classes << 'border-r-0' unless is_last_page
    css_classes.join(' ')
  end
end
