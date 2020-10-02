class Training < ApplicationRecord
  belongs_to :user
  belongs_to :word

  validates :user, :word, :result, presence: true
end
