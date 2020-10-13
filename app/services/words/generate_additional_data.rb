class Words::GenerateAdditionalData < BaseService
  param :word

  def call
    generate_verb_forms if word.part_of_speech_verb?
    result
  end

  private

  def result
    @result ||= {}
  end

  def generate_verb_forms
    verb_forms = word.verb_forms

    result[:tenses] =
      VerbForm.tenses.keys.index_with do |tense|
        VerbForm.pronouns.keys.map do |pronoun|
          verb_forms.find { |vf| vf.tense == tense && vf.pronoun == pronoun }&.spanish
        end
      end
  end
end
