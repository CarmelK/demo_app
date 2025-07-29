
def translate(force: false, locale: nil)
	return false unless should_translate? || force

	I18n.available_locales.each do |language|
		next if language == I18n.default_locale
		next if locale.present? && language != locale.to_sym

		Resque.enqueue_at(enqueue_at, Background::AI::Translate, self.class.name, id, language.to_s)
	end
end
