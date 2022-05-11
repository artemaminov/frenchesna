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
      pictureGroups: {
        avatar: {
          minSize: [100, 100]
        },
        picture: {
          minSize: [1600, 1900]
        }
      }
    };

    this.rcrop.$inputs.on('change', event => this.initCropper(event));
  };

  // open fancy modal window
  // inputName: input name of file field
  openFancy(inputName) {
    $.fancybox.open({
      src: '#' + this.rcrop.$container.attr('id'),
      clickSlide: false,
      touch: false,

      beforeClose : event => {
        this.transferData(inputName);
        this.rcrop.$container.empty();
      }
    });
  };

  launchCropper(filesCount) {
    for (let i = 0; i < filesCount; i++) {
      let currentTab = this.rcrop.tabs[i];
      currentTab.find('img').rcrop({
        // maxSize : [160, 160],
        minSize: [100, 100],
        preserveAspectRatio: true,
        grid: true,
        preview: {
          display: true,
          wrapper: currentTab.find('div'),
          size: [200, 200]
        }
      });
    }
  };

  addCropperTab(i, src) {
    let template = this.rcrop.$template.clone().attr('id', 'rcrop_template_' + i).appendTo(this.rcrop.$container);
    template.find('img')
      .attr('id', 'rcrop_image_' + i)
      .attr('src', src);;
    template.find('div').attr('id', 'rcrop_preview_' + i);
    return template;
  };

  collectData(crop) {
    let cropCmd = crop.width + 'x' + crop.height + '+' + crop.x + '+' +crop.y;
    return cropCmd;
  }

  removeDuplicates(inputName) {
      this.rcrop.$data.find('input[name="' + inputName + '"]').remove();
  }

  transferData(inputName) {
    this.removeDuplicates(inputName);
    for (let i = 0; i < this.rcrop.tabs.length; i++) {
      let currentTab = this.rcrop.tabs[i];
      currentTab['values'] = this.rcrop.tabs[i].find('img').rcrop('getValues');
      $('<input>')
        .attr('name', inputName)
        .val(this.collectData(currentTab['values']))
        .appendTo(this.rcrop.$data);
    }
  }

  inputName(inputName) {
    return inputName.replace(this.rcrop.inputFileName, this.rcrop.rcropAttributeName)
  }

  initCropper(event) {
    this.rcrop.tabs = [];
    const filesCount = event.target.files.length;
    let name = this.inputName(event.target.name);

    if (filesCount > 0) {
      for (let i = 0; i < filesCount; i++) {
        let src = URL.createObjectURL(event.target.files[i]);
        this.rcrop.tabs[i] = this.addCropperTab(i, src);
      }
      this.launchCropper(filesCount);
      this.openFancy(name);

    } else {
      return console.log('No files to crop!');
    }
  };

}

$(function() {
  window.cropper = new Cropper();
});
