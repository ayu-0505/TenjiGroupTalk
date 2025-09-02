class Api::BrailleConvertersController < ApplicationController
  def create
    original_text = params[:text] || ''
    converter = Tenji::Converter.new
    raised_braille = converter.convert_to_tenji(original_text)
    indented_braille = converter.convert_to_oumen(raised_braille)

    render json: { raised: raised_braille, indented: indented_braille }
  end
end
