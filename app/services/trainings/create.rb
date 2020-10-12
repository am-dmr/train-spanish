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

  def es2ru
    result = word.russian.casecmp?(russian) ? 100 : 0
    result_tenses = calc_tenses_result
    result *= result_tenses[1]
    user_input = "#{russian}\n#{result_tenses[0]}"
    Training.create(user: user, word: word, user_input: user_input, result: result)
  end

  def ru2es
    result = 0
    result += 10 if article.blank? || word.articles.any? { |a| a.casecmp?(article) }
    result += 90 if I18n.transliterate(word.spanish).casecmp?(I18n.transliterate(spanish))
    result_tenses = calc_tenses_result
    result *= result_tenses[1]
    user_input = "#{article} #{spanish}\n#{result_tenses[0]}"
    Training.create(user: user, word: word, user_input: user_input, result: result)
  end

  def calc_tenses_result
    return nil, 1 unless word.part_of_speech_verb?

    buf = []
    total = 0
    correct = 0

    VerbForm.tenses.each_key do |tense|
      buf_per_tense = []
      VerbForm.pronouns.each_key do |pronoun|
        verb_form = verb_forms.find { |vf| vf.tense == tense && vf.pronoun == pronoun }
        next if verb_form.blank?

        input = tenses.dig(tense, pronoun)
        next if input.blank?

        total += 1
        buf_per_tense << input
        correct += 1 if I18n.transliterate(verb_form.spanish).casecmp?(input)
      end
      buf << buf_per_tense.join(' - ')
    end

    return '', 1 if total.zero?

    coeff = 0.5 + 0.5 * correct.to_f / total
    [buf.join("\n"), coeff]
  end

  def verb_forms
    @verb_forms ||= word.verb_forms
  end
end
