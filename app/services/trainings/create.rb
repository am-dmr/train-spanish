class Trainings::Create < BaseService
  param :user
  param :word
  param :direction

  option :article, optional: true
  option :spanish, optional: true
  option :russian, optional: true

  def call
    return es2ru if direction == 'es-ru'
    return ru2es if direction == 'ru-es'
  end

  private

  def es2ru
    result = word.russian == russian ? 100 : 0
    Training.create(user: user, word: word, user_input: russian, result: result)
  end

  def ru2es
    result = 0
    result += 10 if article.blank? || word.articles.include?(article)
    result += 90 if word.spanish == spanish
    Training.create(user: user, word: word, user_input: "#{article} #{spanish}", result: result)
  end
end
