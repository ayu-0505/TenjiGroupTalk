require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#turbo_stream_flash' do
    it 'returns a turbo_stream tag that updates the flash template' do
      result = helper.turbo_stream_flash
      document = Nokogiri::HTML::DocumentFragment.parse(result.to_s)
      expect(document.css("turbo-stream[action='update'][target='flash']")).not_to be_empty
    end
  end

  describe '#pagination_page_class' do
    it 'returns unless is_current_page' do
      expect(pagination_page_class(is_current_page: false, is_last_page: true)).to be_nil
      expect(pagination_page_class(is_current_page: false, is_last_page: false)).to be_nil
    end

    it 'returns simple css classes when is_last_page is true' do
      class_names = <<~CLASSES.squish
        current block rounded-md rounded-r-none rounded-l-none border border-slate-300
        py-2 px-3 text-center text-sm transition-all shadow-sm hover:shadow-lg
        text-slate-600 hover:text-white hover:bg-slate-800 hover:border-slate-800
        focus:text-white focus:bg-slate-800 focus:border-slate-800 active:border-slate-800
        bg-teal-300 active:text-white active:bg-slate-800
        disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none
      CLASSES
      expect(pagination_page_class(is_current_page: true, is_last_page: true)).to eq class_names
    end

    it 'returns CSS including border-r-0 when is_last_page is false' do
      class_names = <<~CLASSES.squish
        current block rounded-md rounded-r-none rounded-l-none border border-slate-300
        py-2 px-3 text-center text-sm transition-all shadow-sm hover:shadow-lg
        text-slate-600 hover:text-white hover:bg-slate-800 hover:border-slate-800
        focus:text-white focus:bg-slate-800 focus:border-slate-800 active:border-slate-800
        bg-teal-300 active:text-white active:bg-slate-800
        disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none border-r-0
      CLASSES
      expect(pagination_page_class(is_current_page: true, is_last_page: false)).to eq class_names
    end
  end
end
