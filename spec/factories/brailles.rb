FactoryBot.define do
  factory :braille do
    original_text { 'こんにちは てんじ' }
    raised_braille { '⠪⠴⠇⠗⠥⠀⠟⠴⠐⠳' }
    indented_braille { '⠞⠂⠦⠻ ⠬⠺⠸⠦⠕' }
    user

    factory :talk_braille do
      brailleable factory: :talk
    end

    factory :comment_braille do
      brailleable factory: :comment
    end
  end
end
