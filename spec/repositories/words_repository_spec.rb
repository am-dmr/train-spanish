require 'rails_helper'

describe WordsRepository do
  describe '#new_for_user' do
    subject { described_class.new.new_for_user(user) }

    let(:user) { create(:user) }

    context 'with training' do
      before { create(:training, user: user) }

      it 'returns empty list' do
        expect(subject).to be_empty
      end
    end

    context 'w/o training' do
      let!(:word) { create(:word) }

      it 'returns word' do
        expect(subject).to eq([word])
      end
    end

    context 'with another user training' do
      let!(:word) { create(:training).word }

      it 'returns word' do
        expect(subject).to eq([word])
      end
    end

    context 'correct sorting' do
      let!(:word1) { create(:word) }
      let!(:word2) { create(:word) }

      it 'returns old first' do
        expect(subject.pluck(:id)).to eq([word1.id, word2.id])
      end
    end
  end
end
