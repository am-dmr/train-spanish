FactoryBot.define do
  factory :training do
    user { create(:user) }
    word { create(:word) }
    result { rand(0..100) }
  end
end
