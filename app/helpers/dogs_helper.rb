module DogsHelper
  def svg_tag(name, options = {})
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
    return content_tag(:span, File.read(file_path).html_safe, options) if File.exists?(file_path)
    '(not found)'
  end

  def current_category? category, dog
    'checked' if category.include? dog
  end
end
