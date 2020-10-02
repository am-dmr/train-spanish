require 'rails_helper'

describe WordsController do
  let(:user) { create(:user) }

  describe '#create' do
    subject { post '/words', params: params }

    let(:params) do
      { word: { spanish: 'nino', russian: 'мальчик', part_of_speech: 'noun', articles: 'un,el' } }
    end

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not create Word' do
        expect { subject }.not_to(change { Word.count })
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context 'without params' do
        let(:params) {}

        it_behaves_like('do nothing', 400)
      end

      context 'with error' do
        let(:params) do
          { word: { russian: 'мальчик', part_of_speech: 'noun', articles: 'un,el' } }
        end

        it 'does not create Word' do
          expect { subject }.not_to(change { Word.count })
        end
      end

      context 'with success' do
        it 'creates Word' do
          expect { subject }.to change { Word.count }.by(1)
        end
        it 'creates correct Word' do
          subject
          expect(Word.last).to have_attributes(
            spanish: 'nino',
            russian: 'мальчик',
            part_of_speech: 'noun',
            articles: %w[un el]
          )
        end
      end
    end
  end

  describe '#update' do
    subject { put "/words/#{id}", params: params }

    let(:word) { create(:word) }
    let(:id) { word.id }

    let(:params) do
      { word: { spanish: 'nino', russian: 'мальчик', part_of_speech: 'noun', articles: 'un,el' } }
    end

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not update Word' do
        expect { subject }.not_to(change { word.reload })
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context 'without params' do
        let(:params) {}

        it_behaves_like('do nothing', 400)
      end

      context 'with incorrect ID' do
        let(:id) { word.id + 1 }

        it_behaves_like('do nothing', 404)
      end

      context 'with error' do
        let(:params) do
          { word: { russian: 'мальчик', part_of_speech: 'noun', articles: 'un,el' } }
        end

        it 'does not update Word' do
          expect { subject }.not_to(change { word.reload })
        end
      end

      context 'with success' do
        it 'creates Word' do
          expect { subject }.to change { Word.count }.by(1)
        end
        it 'updates Word correctly' do
          subject
          expect(word.reload).to have_attributes(
            spanish: 'nino',
            russian: 'мальчик',
            part_of_speech: 'noun',
            articles: %w[un el]
          )
        end
      end
    end
  end

  describe '#destroy' do
    subject { delete "/words/#{id}" }

    let!(:word) { create(:word) }
    let(:id) { word.id }

    shared_examples 'do nothing' do |code|
      it "returns #{code}" do
        subject
        expect(response).to have_http_status(code)
      end
      it 'does not delete Word' do
        expect { subject }.not_to(change { Word.count })
      end
    end

    context 'without current user' do
      it_behaves_like('do nothing', 401)
    end

    context 'with current user' do
      before { sign_in(user) }

      context 'with incorrect ID' do
        let(:id) { word.id + 1 }

        it_behaves_like('do nothing', 404)
      end

      context 'with success' do
        it 'deletes Word' do
          expect { subject }.to change { Word.count }.by(-1)
        end
      end
    end
  end
end
