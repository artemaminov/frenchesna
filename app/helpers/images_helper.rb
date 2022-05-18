module ImagesHelper

  IMAGE_TYPES = {
    avatar: {
      resize: '84x84'
    },
    background: {
      resize: '1400x900'
    },
    picture: {
      resize: '1400x900'
    }
  }

  def crop_image(image, image_type = :picture, resize = IMAGE_TYPES[image_type][:resize])
    if image.respond_to?('crop') && image.crop.present?
      url_for image.file.variant(crop: image.crop, resize: resize).processed
    else
      url_for image.file.variant(resize: resize).processed
    end
  end
end
