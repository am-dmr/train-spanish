class TrainingsRepository < BaseRepository
  def old_trainings_for_user(user)
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
      .where(user_id: user.id)
      .order(id: :asc)
      .limit(25)
  end
end
