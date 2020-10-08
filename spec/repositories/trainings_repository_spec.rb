require 'rails_helper'

describe TrainingsRepository do
  describe '#old_trainings_for_user' do
    subject { described_class.new.old_trainings_for_user(user) }

    let(:user) { create(:user) }

    context 'wrong user' do
      before { create(:training) }

      it 'returns empty list' do
        expect(subject).to be_empty
      end
    end

    context 'correct sorting' do
      let(:word1) { create(:word) }
      let(:word2) { create(:word) }

      let!(:trainings) do
        [
          create(:training, word: word1, user: user),
          create(:training, word: word2, user: user),
          create(:training, word: word1, user: user),
          create(:training, word: word2, user: user)
        ]
      end

      it 'returns list with the oldest of the newest (per word)' do
        expect(subject.pluck(:id)).to eq([trainings[2].id, trainings[3].id])
      end
    end
  end
end
