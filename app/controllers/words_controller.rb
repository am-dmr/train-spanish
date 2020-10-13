class WordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @words = Word.order(spanish: :asc).page(params[:page]).per(25)
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.create(word_params)

    if @word.persisted?
      flash[:notice] = 'Word created!'
      redirect_to words_path
    else
      flash[:alert] = 'Word has error!'
      render :new
    end
  end

  def edit
    @word = Word.find(params[:id])
  end

  def update
    @word = Word.find(params[:id])

    if @word.update(word_params)
      flash[:notice] = 'Word updated!'
      redirect_to words_path
    else
      flash[:alert] = 'Word has error!'
      render :edit
    end
  end

  def fill_verb_forms
    @word = Word.find(params[:id])
    @verb_forms = @word.verb_forms
  end

  def create_verb_forms
    word = Word.find(params[:id])
    data = params.require(:word).permit.tap do |whitelisted|
      VerbForm.tenses.each_key do |tense|
        whitelisted[tense] = params[:word][tense]&.permit!
      end
    end.to_h
    Words::CreateVerbForms.call(word, data)
    redirect_to words_path
  end

  def destroy
    @word = Word.find(params[:id])
    if @word.destroy
      flash[:notice] = 'Word destroyed'
    else
      flash[:alert] = 'Unable to delete word'
    end
    redirect_to words_path
  end

  private

  def word_params
    pp =
      params
      .require(:word)
      .permit(:spanish,
              :russian,
              :part_of_speech,
              :articles)
    pp[:articles] = (pp[:articles] || '').split(',').map(&:strip)
    pp
  end
end
