require 'rails_helper'

describe Words::GenerateAdditionalData do
  subject { described_class.call(word) }

  context 'not verb' do
    let(:word) { create(:word, part_of_speech: :noun) }

    it 'returns blank hash' do
      expect(subject).to eq({})
    end
  end

  context 'verb' do
    let(:word) { create(:word, part_of_speech: :verb) }

    before do
      create(:verb_form, word: word, tense: :presente_simple, pronoun: :yo, spanish: 'hablo')
      create(:verb_form, word: word, tense: :presente_simple, pronoun: :el_usted, spanish: 'habla')
    end

    it 'returns hash with tenses' do
      expect(subject)
        .to eq(
          tenses: {
            'preterito_simple' => Array.new(6),
            'presente_simple' => ['hablo', nil, 'habla', nil, nil, nil],
            'futuro_simple' => Array.new(6)
          }
        )
    end
  end
end
