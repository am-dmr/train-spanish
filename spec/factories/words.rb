FactoryBot.define do
  factory :word do
    spanish { 'Nina' }
    russian { 'Девочка' }
    articles { %w[una la] }
    part_of_speech { :noun }
  end
end
