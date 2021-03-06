require 'rails_helper'

describe Word do
  describe 'associations' do
    it { is_expected.to have_many(:trainings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:spanish) }
    it { is_expected.to validate_presence_of(:russian) }
    it { is_expected.to validate_presence_of(:part_of_speech) }
  end
end
