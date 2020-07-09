class ApplicationController < ActionController::Base

  before_action :set_locale

  def get_menu_items
    @dogs = Dog.adults.alive
    @puppies = Dog.puppies
  end

  private

  def set_locale
    detected_locale = request.subdomains.first
    I18n.locale = I18n.available_locales.map(&:to_s).include?(detected_locale) ? detected_locale : (browser_locale || I18n.default_locale)
  end

  def browser_locale
    locales = request.env['HTTP_ACCEPT_LANGUAGE'] || ''
    locales.scan(/[a-z]{2}(?=\;)/).find do |locale|
      I18n.available_locales.include?(locale.to_sym)
    end
  end

end
