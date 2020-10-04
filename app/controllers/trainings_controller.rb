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
      return
    else
      @training = Training.new(word: @word, user: current_user)
    end
  end

  def create
    redirect_to new_training_path(direction: params[:training][:direction],
                                  word_type: params[:training][:word_type])
  end

  private

  def new_words
    Word
      .joins(<<~SQL)
        LEFT JOIN trainings
          ON trainings.word_id = words.id
          AND trainings.user_id = #{current_user.id}
      SQL
      .where(trainings: { id: nil })
      .order(created_at: :desc)
  end

  def old_words
    Training
      .includes(:word)
      .where(user_id: current_user.id)
      .order(created_at: :asc)
  end
end
