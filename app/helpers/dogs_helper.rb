module DogsHelper
  def svg_tag(name, options)
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
    return content_tag(:span, File.read(file_path).html_safe, options) if File.exists?(file_path)
    '(not found)'
  end
end
