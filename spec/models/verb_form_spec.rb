require 'rails_helper'

describe VerbForm do
  describe 'associations' do
    it { is_expected.to belong_to(:word) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:word) }
    it { is_expected.to validate_presence_of(:tense) }
    it { is_expected.to validate_presence_of(:pronoun) }
    it { is_expected.to validate_presence_of(:spanish) }
  end
end
