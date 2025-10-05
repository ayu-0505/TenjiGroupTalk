require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it 'returns a turbo_stream tag that updates the flash template' do
    result = helper.turbo_stream_flash
    document = Nokogiri::HTML::DocumentFragment.parse(result.to_s)
    expect(document.css("turbo-stream[action='update'][target='flash']")).not_to be_empty
  end
end
