FactoryBot.define do
  factory :braille do
    original_text { "MyText" }
    raised_braille { "MyText" }
    indented_braille { "MyText" }
    user { nil }
    brailleable { nil }
  end
end
