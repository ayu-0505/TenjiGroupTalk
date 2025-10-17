FactoryBot.define do
  factory :braille do
    original_text { 'こんにちわ てんじ' }
    raised_braille { '⠪⠴⠇⠗⠄⠀⠟⠴⠐⠳' }
    indented_braille { '⠞⠂⠦⠻⠀⠠⠺⠸⠦⠕' }
    user
  end
end
