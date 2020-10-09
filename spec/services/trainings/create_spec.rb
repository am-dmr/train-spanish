require 'rails_helper'

describe Trainings::Create do
  subject { described_class.call(user, word, direction, article: article, spanish: spanish, russian: russian) }

  let(:user) { create(:user) }
  let(:word) { create(:word, articles: %w[un el], spanish: 'nino', russian: 'мальчик') }

  let(:article) { '' }
  let(:spanish) { '' }
  let(:russian) { '' }

  shared_examples 'creates Training' do |result, user_input|
    it 'creates Training' do
      expect { subject }.to change { Training.count }.by(1)
    end
    it 'creates correct Training' do
      subject
      expect(Training.last)
        .to have_attributes(word_id: word.id,
                            user_id: user.id,
                            result: result,
                            user_input: user_input)
    end
  end

  describe '#es2ru' do
    let(:direction) { 'es-ru' }
    let(:russian) { 'мальчик' }

    context 'w/correct word' do
      it_behaves_like 'creates Training', 100, 'мальчик'
    end

    context 'w/correct word (case insensitive)' do
      let(:russian) { 'малЬчик' }

      it_behaves_like 'creates Training', 100, 'малЬчик'
    end

    context 'w/incorrect word' do
      let(:russian) { 'пальчик' }

      it_behaves_like 'creates Training', 0, 'пальчик'
    end
  end

  describe '#ru2es' do
    let(:direction) { 'ru-es' }
    let(:article) { 'el' }
    let(:spanish) { 'nino' }

    context 'with correct article & word' do
      it_behaves_like 'creates Training', 100, 'el nino'
    end

    context 'correct with diacritics' do
      let(:word) { create(:word, articles: %w[un el], spanish: 'niño', russian: 'мальчик') }

      it_behaves_like 'creates Training', 100, 'el nino'
    end

    context 'without article & cased word' do
      let(:article) { '' }
      let(:spanish) { 'nINo' }

      it_behaves_like 'creates Training', 100, ' nINo'
    end

    context 'correct word & incorrect article' do
      let(:article) { 'una' }
      let(:spanish) { 'nino' }

      it_behaves_like 'creates Training', 90, 'una nino'
    end

    context 'incorrect word & correct article' do
      let(:article) { 'un' }
      let(:spanish) { 'nina' }

      it_behaves_like 'creates Training', 10, 'un nina'
    end

    context 'incorrect word & article' do
      let(:article) { 'una' }
      let(:spanish) { 'nina' }

      it_behaves_like 'creates Training', 0, 'una nina'
    end
  end
end
