require 'rails_helper'

describe Training do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:word) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:word) }
    it { is_expected.to validate_presence_of(:result) }
  end
end
