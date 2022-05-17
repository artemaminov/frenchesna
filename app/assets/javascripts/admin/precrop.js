class Cropper {

  constructor() {
    this.rcrop = {
      tabs: new Set(), // stores cropper objects
      inputFileName: 'file', // input file field class name
      rcropAttributeName: 'crop', // attribute name of input's name/array
      $inputs: $('.rcrop'), // main eventListener element name
      $container: $('#rcrop_container'), // modal window object
      $data: $('#rcrop_data'), // element stores cropper data inputs
      $template: $('#rcrop_template'), // template object with cropper img and preview
      typesAllowed: ['image/png', 'image/jpg'],
      pictureTypes: {
        avatar: {
          fileInputName: 'dog[avatar_attributes][file]',
          cropInputName: 'dog[avatar_attributes][crop]',
          minSizeInputName: 'dog[avatar_attributes][resize]',
          minSize: [84, 84]
        },
        picture: {
          fileInputName: 'dog[gallery_pictures_attributes][][file]',
          cropInputName: 'dog[gallery_pictures_attributes][][crop]',
          minSizeInputName: 'dog[gallery_pictures_attributes][][resize]',
          minSize: [1400, 900]
        }
      },
    };

    this.rcrop.$inputs.attr('accept', this.rcrop.typesAllowed.join(','));
    this.rcrop.$inputs.on('change', event => this.initCropper(event));
  };

  // open fancy modal window
  // inputName: input name of file field
  openFancy(pictureType) {
    $.fancybox.open({
      src: '#' + this.rcrop.$container.attr('id'),
      clickSlide: false,
      touch: false,

      beforeClose: event => {
        this.transferData(pictureType);
        this.rcrop.$container.empty();
      }
    });
  };

  launchCropper(pictureType) {
    const minSizeX = this.rcrop.pictureTypes[pictureType].minSize[0]
    const minSizeY = this.rcrop.pictureTypes[pictureType].minSize[1]
    for (const currentTab of this.rcrop.tabs) {
      const cropper = currentTab.find('.rcrop_cropper')
      const ratio = minSizeY / minSizeX
      const ratioY = 200 * ratio
      cropper.rcrop({
        minSize: this.rcrop.pictureTypes[pictureType].minSize,
        preserveAspectRatio: true,
        grid: true,
        preview: {
          display: true,
          wrapper: currentTab.find('.rcrop_preview'),
          size: [200, ratioY]
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

  clearInputs(inputName) {
    const cropInputs = 'input[name="' + this.rcrop.pictureTypes[inputName].cropInputName + '"]';
    const sizeInputs = 'input[name="' + this.rcrop.pictureTypes[inputName].minSizeInputName + '"]';
    const fileInputs = 'input[name="' + this.rcrop.pictureTypes[inputName].fileInputName + '"]';
      this.rcrop.$data
        .find(cropInputs)
        .add(sizeInputs, this.rcrop.$data)
        .add(fileInputs, this.rcrop.$data)
        .remove();
  }

  generateFileInput(pictureType, i) {
    const inputField = this.rcrop.pictureTypes[pictureType].fileInputName
    const dt = new DataTransfer()
    const { files } = document.querySelector('input[name="' + inputField + '"]')
    const file = files[i]
    const newInput = document.createElement('input')
    newInput.setAttribute('type', 'file')
    newInput.setAttribute('name', this.rcrop.pictureTypes[pictureType].fileInputName)
    newInput.setAttribute('data-direct-upload-url', 'http://localhost:3000/rails/active_storage/direct_uploads')
    dt.items.add(file)
    newInput.files = dt.files
    this.rcrop.$data.append(newInput)
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
    let i = 0;
    this.clearInputs(pictureType);
    for (const currentTab of this.rcrop.tabs) {
      currentTab['values'] = currentTab.find('img').rcrop('getValues');
      this.generateFileInput(pictureType, i);
      this.generateInputField(pictureType, currentTab['values']);
      i++
    }
    this.disableMainInputs()
  }

  checkImageDimensions(src, pictureType) {
    return new Promise((resolve, reject) => {
      let image = new Image();
      image.src = src;
      image.onload = (event) => {
        if (event.target.naturalWidth < this.rcrop.pictureTypes[pictureType].minSize[0] ||
          event.target.naturalHeight < this.rcrop.pictureTypes[pictureType].minSize[1]
        ) {
          alert('Изображение меньше минимальных размеров: ' + this.rcrop.pictureTypes[pictureType].minSize.join('x'));
          resolve(false);
        } else {
          resolve(true);
        }
      }
    });
  }

  disableMainInputs() {
    const inputs = this.rcrop.$inputs;
    for (const input of inputs) {
      input.files = new DataTransfer().files;
    }
  }

  processFilesFromFileList(filesToRemove, inputField) {
    const DT = new DataTransfer()
    const { files } = inputField
    for (let i = 0; i < files.length; i++) {
      const file = files[i]
      if (!filesToRemove.includes(i)) // Add file to FileList if it's not in the filesToRemove array
        DT.items.add(file)
    }
    inputField.files = DT.files // Assign the updated list
  }

  async initCropper(event) {
    this.rcrop.tabs.clear(); // Clean tabs array
    const filesCount = event.target.files.length; // Get files count
    const pictureType = $(event.target).data('rcrop-picture-type');
    let filesToRemove = [];

    if (filesCount > 0) {
      for (let i = 0; i < filesCount; i++) {
        let src = URL.createObjectURL(event.target.files[i]);
        if (await this.checkImageDimensions(src, pictureType) === true) {
          this.rcrop.tabs.add(this.addCropperTab(i, src));
        } else {
          filesToRemove.push(i);
        }
      }
    }
    this.processFilesFromFileList(filesToRemove, event.target);
    this.launchCropper(pictureType);
    this.openFancy(pictureType);
  };

}

$(function() {
  window.cropper = new Cropper();
});
