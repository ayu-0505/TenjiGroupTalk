class Braille < ApplicationRecord
  belongs_to :user
  has_one :talk, dependent: :nullify
  has_one :comment, dependent: :nullify

  before_validation :initialize_braille, on: %i[create update]

  def converter
    Tenji::Converter.new
  end

  def same_content?(original_text)
    self.original_text == original_text
  end

    private

  def initialize_braille
    if original_text.present?
      self.raised_braille = converter.convert_to_tenji(original_text)
    else
      self.raised_braille = nil
    end
    generate_indented_braille
  end

  def generate_indented_braille
    if raised_braille.present?
      self.indented_braille = converter.convert_to_oumen(raised_braille)
    else
      self.indented_braille = nil
    end
  end
end
