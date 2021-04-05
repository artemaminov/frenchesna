class ApplicationController < ActionController::Base

  before_action :set_locale

  def get_menu_items
    @dogs = Dog.adults.alive.sort_by_breed.sort_by_birth.sort_by_name
    @puppies = Dog.puppies.sort_by_breed.sort_by_birth.sort_by_name
  end

  private

  def set_locale
    # explicit param can always override existing setting
    # otherwise, make sure to allow a user preference to override any automatic detection
    # then detect by location, and header
    # if all else fails, fall back to default
    I18n.locale = params[:locale] || session[:locale] || subdomain_locale || location_detected_locale || header_detected_locale || I18n.default_locale

    # save to session
    session[:locale] = I18n.locale
  end

  # these could potentially do with a bit of tidying up
  # remember to return `nil` to indicate no match

  def location_detected_locale
    location = request.location
    return nil unless location.present? && location.country_code.present? && I18n.available_locales.include?(location.country_code)
    location.country_code.include?("-") ? location.country_code : location.country_code.downcase
  end

  def header_detected_locale
    return nil unless (request.env["HTTP_ACCEPT_LANGUAGE"] || "en").scan(/^[a-z]{2}/).first.present? && I18n.available_locales.include?((request.env["HTTP_ACCEPT_LANGUAGE"] || "en").scan(/^[a-z]{2}/).first)
    (request.env["HTTP_ACCEPT_LANGUAGE"] || "en").scan(/^[a-z]{2}/).first
  end

  def subdomain_locale
    detected_locale = request.subdomains.first
    I18n.available_locales.map(&:to_s).include?(detected_locale) ? detected_locale : browser_locale
  end

  def browser_locale
    locales = request.env['HTTP_ACCEPT_LANGUAGE'] || ''
    locales.scan(/[a-z]{2}(?=\;)/).find do |locale|
      I18n.available_locales.include?(locale.to_sym)
    end
  end

end
