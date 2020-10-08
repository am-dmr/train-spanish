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
      last_training
      @training = Training.new(word: @word, user: current_user)
    end
  end

  def create
    word = Word.find params[:training][:word_id]
    training =
      if params[:training][:direction] == 'es-ru'
        result = word.russian == params[:training][:russian] ? 100 : 0
        Training.create(user: current_user, word: word, result: result)
      end

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
    relation =
      Training
        .joins(<<~SQL)
          JOIN (
            SELECT MAX(trainings.id) AS id, user_id, word_id
            FROM trainings
            GROUP BY user_id, word_id
          ) AS last_trainings
          ON last_trainings.id = trainings.id
        SQL
        .includes(:word)
        .where(user_id: current_user.id)
    relation.order(id: :asc)
  end
end
