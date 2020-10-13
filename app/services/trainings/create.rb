class Trainings::Create < BaseService
  param :user
  param :word
  param :direction

  option :article, optional: true
  option :spanish, optional: true
  option :russian, optional: true
  option :tenses, optional: true

  def call
    return es2ru if direction == 'es-ru'
    return ru2es if direction == 'ru-es'
  end

  private

  def additional_input
    @additional_input ||= {}
  end

  def result
    @result ||= 0
  end

  def user_input
    @user_input ||= ''
  end

  def tenses_coeff
    @tenses_coeff ||= 1
  end

  def es2ru
    @result = word.russian.casecmp?(russian) ? 100 : 0
    @user_input = russian
    calc_tenses_result
    create_record
  end

  def ru2es
    @result = 0
    @result += 10 if article.blank? || word.articles.any? { |a| a.casecmp?(article) }
    @result += 90 if spanish_casecmp?(word.spanish, spanish)
    @user_input = "#{article} #{spanish}"

    calc_tenses_result
    create_record
  end

  def spanish_casecmp?(first, second)
    I18n.transliterate(first).casecmp?(I18n.transliterate(second))
  end

  def calc_tenses_result
    return unless word.part_of_speech_verb?

    result_input = {}
    total = 0
    correct = 0

    VerbForm.tenses.each_key do |tense|
      result_input[tense] = []
      VerbForm.pronouns.each_key do |pronoun|
        verb_form = find_verb_form(tense, pronoun)
        user_input = tenses.dig(tense, pronoun)
        result_input[tense] << user_input
        next if verb_form.blank? || user_input.blank?

        total += 1
        correct += 1 if spanish_casecmp?(verb_form.spanish, user_input)
      end
    end

    @tenses_coeff = 0.5 + 0.5 * correct.to_f / total
    @additional_input[:tenses] = result_input
  end

  def create_record
    Training.create(user: user,
                    word: word,
                    user_input: user_input,
                    additional_input: additional_input,
                    result: result * tenses_coeff)
  end

  def verb_forms
    @verb_forms ||= word.verb_forms
  end

  def find_verb_form(tense, pronoun)
    verb_forms.find { |vf| vf.tense == tense && vf.pronoun == pronoun }
  end
end
