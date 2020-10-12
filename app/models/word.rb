class Word < ApplicationRecord
  enum part_of_speech: {
    not_applicable: 0,
    noun: 1,
    pronoun: 2,
    verb: 3,
    adjective: 4,
    numeral: 5,
    adverb: 6
  }, _prefix: :part_of_speech

  has_many :trainings, dependent: :destroy
  has_many :verb_forms, dependent: :destroy

  validates :spanish, :russian, :part_of_speech, presence: true
end
