require 'rails_helper'

describe Words::CreateVerbForms do
  subject { described_class.call(word, data) }

  let(:word) { create(:word) }
  let!(:form_same) { create(:verb_form, word: word, tense: :presente_simple, pronoun: :yo, spanish: 'hablo') }
  let!(:form_diff) { create(:verb_form, word: word, tense: :presente_simple, pronoun: :tu, spanish: 'hablar') }

  context 'blank data' do
    let(:data) {}

    it 'does not change same' do
      expect { subject }.not_to(change { form_same.reload })
    end
    it 'does not change diff' do
      expect { subject }.not_to(change { form_diff.reload })
    end
  end

  context 'data with updates & new' do
    let(:data) do
      {
        'presente_simple' => { 'yo' => 'hablo', 'tu' => 'hablas', 'el_usted' => 'habla' }
      }
    end

    it 'does not change same' do
      expect { subject }.not_to(change { form_same.reload })
    end
    it 'changes diff' do
      expect { subject }.to change { form_diff.reload.spanish }.to('hablas')
    end
    it 'creates new form' do
      expect { subject }.to change { VerbForm.count }.by(1)
    end
    it 'creates new form correctly' do
      subject
      expect(VerbForm.last)
        .to have_attributes(
          word_id: word.id,
          tense: 'presente_simple',
          pronoun: 'el_usted',
          spanish: 'habla'
        )
    end
  end
end
