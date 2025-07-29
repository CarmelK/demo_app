class User < ActiveRecord::Base
	has_many :microposts

	def translate1(force: false, locale: nil)
      return false unless should_translate? || force

      enqueue_at = translation_delay.from_now

      if locale.present?
        Resque.enqueue_at(enqueue_at, Background::AI::Translate, self.class.name, id, locale.to_s)

        return true
      end

      (I18n.available_locales - I18n.default_locale).each do |language|
        Resque.enqueue_at(enqueue_at, Background::AI::Translate, self.class.name, id, language.to_s)
      end

      true
    end

	def translate2(force: false, locale: nil)
		return false unless should_translate? || force

		I18n.available_locales.each do |language|
    		next if language == I18n.default_locale
    		next if locale.present? && language != locale.to_sym
   
  		  	Resque.enqueue_at(enqueue_at, Background::AI::Translate, self.class.name, id, language.to_s)
		end
	end
end
