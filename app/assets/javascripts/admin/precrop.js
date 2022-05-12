class Cropper {

  constructor() {
    this.rcrop = {
      tabs: [], // stores cropper objects
      inputFileName: 'file', // input file field class name
      rcropAttributeName: 'crop', // attribute name of input's name/array
      $inputs: $('.rcrop'), // main eventListener element name
      $container: $('#rcrop_container'), // modal window object
      $data: $('#rcrop_data'), // element stores cropper data inputs
      $template: $('#rcrop_template'), // template object with cropper img and preview
      typesAllowed: ['image/png', 'image/jpg'],
      pictureTypes: {
        avatar: {
          cropInputName: 'dog[avatar_attributes][crop]',
          minSizeInputName: 'dog[avatar_attributes][resize]',
          minSize: [84, 84]
        },
        picture: {
          cropInputName: 'dog[gallery_pictures_attributes][][crop]',
          minSizeInputName: 'dog[gallery_pictures_attributes][][resize]',
          minSize: [1400, 900]
        }
      },
    };

    this.rcrop.$inputs.on('change', event => this.initCropper(event));
  };

  // open fancy modal window
  // inputName: input name of file field
  openFancy(pictureType) {
    $.fancybox.open({
      src: '#' + this.rcrop.$container.attr('id'),
      clickSlide: false,
      touch: false,

      beforeClose : event => {
        this.transferData(pictureType);
        this.rcrop.$container.empty();
      }
    });
  };

  launchCropper(filesCount) {
    for (let i = 0; i < filesCount; i++) {
      let currentTab = this.rcrop.tabs[i];
        // maxSize : [160, 160],
        minSize: [100, 100],
      currentTab.find('.rcrop_cropper').rcrop({
        preserveAspectRatio: true,
        grid: true,
        preview: {
          display: true,
          wrapper: currentTab.find('.rcrop_preview'),
          size: [200, 200]
        }
      });
    }
  };

  addCropperTab(i, src) {
    let template = this.rcrop.$template.clone().attr('id', 'rcrop_template_' + i).appendTo(this.rcrop.$container);
    template.find('.rcrop_cropper')
      .attr('id', 'rcrop_image_' + i)
      .attr('src', src);

    template.find('.rcrop_preview').attr('id', 'rcrop_preview_' + i);
    return template;
  };

  collectData(crop, pictureType) {
    let cropCmd = crop.width + 'x' + crop.height + '+' + crop.x + '+' +crop.y;
    let resizeCmd = this.rcrop.pictureTypes[pictureType].minSize.join('x');
    return [cropCmd, resizeCmd];
  }

  removeDuplicates(inputName) {
    let cropInputs = 'input[name="' + this.rcrop.pictureTypes[inputName].cropInputName + '"]';
    let sizeInputs = 'input[name="' + this.rcrop.pictureTypes[inputName].minSizeInputName + '"]';
      this.rcrop.$data
        .find(cropInputs)
        .add(sizeInputs)
        .remove();
  }

  generateInputField(pictureType, values) {
    $('<input>')
      .attr('name', this.rcrop.pictureTypes[pictureType].cropInputName)
      .val(this.collectData(values, pictureType)[0])
      .appendTo(this.rcrop.$data);
    $('<input>')
      .attr('name', this.rcrop.pictureTypes[pictureType].minSizeInputName)
      .val(this.collectData(values, pictureType)[1])
      .appendTo(this.rcrop.$data);
  }

  transferData(pictureType) {
    this.removeDuplicates(pictureType);
    for (let i = 0; i < this.rcrop.tabs.length; i++) {
      let currentTab = this.rcrop.tabs[i];
      currentTab['values'] = this.rcrop.tabs[i].find('img').rcrop('getValues');
      this.generateInputField(pictureType, currentTab['values']);
    }
  }

  initCropper(event) {
    this.rcrop.tabs = []; // Clean tabs array
    const filesCount = event.target.files.length; // Get files count
    let pictureType = $(event.target).data('rcrop-picture-type');

    if (filesCount > 0) {
      for (let i = 0; i < filesCount; i++) {
        let src = URL.createObjectURL(event.target.files[i]);
        this.rcrop.tabs[i] = this.addCropperTab(i, src);
      }
      this.launchCropper(filesCount);
      this.openFancy(pictureType);

    } else {
      return console.log('No files to crop!');
    }
  };

}

$(function() {
  window.cropper = new Cropper();
});
