class TrainingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @new_words = new_words
    @old_words = old_words
  end

  def new
    @word = params[:word_type] == 'new' ? new_words.first : old_words.first&.word
    if @word.blank?
      redirect_to trainings_path
    else
      last_training
      @verb_forms = @word.verb_forms
      @training = Training.new(word: @word, user: current_user)
    end
  end

  def create
    word = Word.find params[:training][:word_id]
    training = Trainings::Create.call(current_user, word, params[:training][:direction], **training_params)

    redirect_to new_training_path(direction: params[:training][:direction],
                                  word_type: params[:training][:word_type],
                                  last_training_id: training.id)
  end

  private

  def last_training
    return nil if params[:last_training_id].blank?

    @last_training ||= Training.find(params[:last_training_id])
  end

  def new_words
    @new_words ||= WordsRepository.new.new_for_user(current_user)
  end

  def old_words
    @old_words ||= TrainingsRepository.new.old_trainings_for_user(current_user)
  end

  def training_params
    @training_params ||=
      params.require(:training).permit(:article, :spanish, :russian).tap do |whitelisted|
        whitelisted[:tenses] = {}
        VerbForm.tenses.each_key do |tense|
          whitelisted[:tenses][tense] = params[:training][tense]&.permit!
        end
        whitelisted[:tenses].permit!
      end.to_h.symbolize_keys
  end
end
