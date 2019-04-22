class Preference < ApplicationRecord
  has_one_attached :background

  def self.background
    prefs = Preference.first
    prefs.background if prefs
  end

  def self.about
    prefs = Preference.first
    prefs.about if prefs
  end

end
