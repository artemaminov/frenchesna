function crop(event) {
  if (event.target.files.length > 0) {
    let src = URL.createObjectURL(event.target.files[0]);
    let rcrop_container = $("#rcrop_container");
    let rcrop_image = $("#rcrop_image");
    rcrop_image.attr('src', src);
    $.fancybox.open({
      src: '#rcrop_container'
    });
    rcrop_image.rcrop({
      minSize : [160,160],
      preserveAspectRatio : true,
      grid : true,
      preview : {
        display: true,
        size : [80,45]
      }
    });
  }
}

$(function() {
  const avatarImage = $("#dog_viewable_id");
  avatarImage.on('change', crop);
});
