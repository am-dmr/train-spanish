class WordsRepository < BaseRepository
  def new_for_user(user)
    Word
      .joins(<<~SQL)
        LEFT JOIN trainings
          ON trainings.word_id = words.id
          AND trainings.user_id = #{user.id}
      SQL
      .where(trainings: { id: nil })
      .order(created_at: :asc)
      .limit(25)
  end
end
