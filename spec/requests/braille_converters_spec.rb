require 'rails_helper'

RSpec.describe '/api/braille_converters', type: :request do
  context 'when text is provided' do
    it 'returns converted braille' do
      user = create(:user)
      sign_in(user)
      post '/api/braille_converter', params: { text: 'こんにちわ' }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['raised']).to eq('⠪⠴⠇⠗⠄')
      expect(json['indented']).to eq('⠠⠺⠸⠦⠕')
    end
  end


  context 'when the text is empty' do
    it 'returns an empty string' do
      user = create(:user)
      sign_in(user)
      post '/api/braille_converter', params: { text: '' }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['raised']).to eq('')
      expect(json['indented']).to eq('')
    end
  end
end
