require 'rails_helper'

describe TrainingsController do
  let(:user) { create(:user) }

  shared_examples '401' do
    it 'returns 401' do
      subject
      expect(response).to have_http_status(401)
    end
  end

  describe '#new' do
    subject { get '/trainings/new', params: params }

    let(:params) { { word_type: 'new' } }

    it_behaves_like '401'

    context 'new words' do
      before { sign_in(user) }

      context 'w/o avilable words' do
        it 'redirects to index' do
          expect(subject).to redirect_to(action: :index)
        end
      end

      context 'w/available words' do
        before { create(:word) }

        it 'renders form' do
          expect(subject).to render_template(:new)
        end
      end
    end

    context 'old words' do
      let(:params) { { word_type: 'old' } }

      before { sign_in(user) }

      context 'w/o avilable words' do
        before { create(:word) }

        it 'redirects to index' do
          expect(subject).to redirect_to(action: :index)
        end
      end

      context 'w/available words' do
        before { create(:training, user: user) }

        it 'renders form' do
          expect(subject).to render_template(:new)
        end
      end
    end
  end

  describe '#create' do
    subject { post '/trainings', params: params }

    let(:word) { create(:word) }
    let(:params) { { training: { russian: 'мальчик', word_id: word.id, direction: 'es-ru', word_type: 'new' } } }

    it_behaves_like '401'

    context 'logged in' do
      before { sign_in(user) }

      it 'calls Trainings::Create' do
        expect(Trainings::Create).to receive(:call).with(user, word, 'es-ru', russian: 'мальчик').and_call_original
        subject
      end
      it 'redirects to new' do
        expect(subject)
          .to redirect_to(action: :new, direction: 'es-ru', last_training_id: Training.last.id, word_type: 'new')
      end
    end
  end
end
