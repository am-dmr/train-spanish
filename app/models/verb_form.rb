class VerbForm < ApplicationRecord
  enum tense: {
    presente_simple: 1,
    preterito_simple: 2,
    futuro_simple: 3
  }, _prefix: :tense

  enum pronoun: {
    yo: 1,
    tu: 2,
    el_usted: 3,
    nosotros: 4,
    vosotros: 5,
    ellos_ustedes: 6
  }, _prefix: :pronoun

  include WithEnum

  belongs_to :word

  validates :word, :tense, :pronoun, :spanish, presence: true
end
