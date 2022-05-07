class Cropper {

  constructor(selectors) {
    this.cropperTabs = [];
    this.imageProps = {
      typesAllowed: ['image/png', 'image/jpg'],
      avatar: {
        minSize: [100, 100]
      },
      picture: {
        minSize: [1600, 1900]
      }
    };
    this.rcrop = {
      container: $('#rcrop_container'),
      template: $('#rcrop_template'),
      image: $('#rcrop_template img'),
      previewWrapper: $('#rcrop_template div'),
    };

    $(selectors).on('change', event => this.initCropper(event));
  };

  openFancy() {
    console.log(this.rcrop.container[0]);
    $.fancybox.open({
      src: '#' + this.rcrop.container.attr('id'),
      clickSlide: false,
      touch: false,

      beforeClose : event => {
        this.transferData();
        this.rcrop.container.children().remove('*');
      }
    });
  };

  launchCropper(filesCount) {
    for (let i = 0; i < filesCount; i++) {
      this.cropperTabs[i].find('img').rcrop({
        // maxSize : [160, 160],
        minSize: [100, 100],
        preserveAspectRatio: true,
        grid: true,
        preview: {
          display: true,
          wrapper: this.cropperTabs[i].find('div'),
          size: [200, 200]
        }
      });
    }
  };

  addCropperTab(i) {
    let template = this.rcrop.template.clone().attr('id', 'rcrop_template_' + i).appendTo(this.rcrop.container);
    template.find('img').attr('id', 'rcrop_image_' + i);
    template.find('div').attr('id', 'rcrop_preview_' + i);
    return template;
  };

  transferData() {
    for (let i = 0; i < this.cropperTabs.length; i++) {
      this.cropperTabs[i]['values'] = this.cropperTabs[i].find('img').rcrop('getValues');
    }
  }

  initCropper(event) {
    const filesCount = event.target.files.length;
    if (filesCount > 0) {
      for (let i = 0; i < filesCount; i++) {
        this.cropperTabs[i] = this.addCropperTab(i);

        let src = URL.createObjectURL(event.target.files[i]);

        this.cropperTabs[i].find('img').attr('src', src);
        this.launchCropper(filesCount);
      }
      this.openFancy();

    } else {
      return console.log('No files to crop!');
    }
  };

}

$(function() {
  window.cropper = new Cropper('#dog_viewable_id, #dog_picture_ids');
});
