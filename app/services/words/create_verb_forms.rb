class Words::CreateVerbForms < BaseService
  param :word
  param :data

  def call
    verb_forms = word.verb_forms

    data.each do |tense, pronouns|
      pronouns.each do |pronoun, spanish|
        next if spanish.blank?

        verb_form = verb_forms.find { |vf| vf.tense == tense && vf.pronoun == pronoun }
        verb_form ||= word.verb_forms.new(tense: tense, pronoun: pronoun)
        next if verb_form.spanish == spanish

        verb_form.spanish = spanish
        verb_form.save
      end
    end
  end
end
