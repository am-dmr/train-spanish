FactoryBot.define do
  factory :verb_form do
    word { create(:word, part_of_speech: :verb) }
    tense { :presente_simple }
    pronoun { :yo }
    spanish { 'hablo' }
  end
end
