(function() {
    this.addLitter = function(btn) {
        let $btn = $(btn);
        let $litterList = $('#add-litter ol');
        let state = $btn.data('add-litter-state');
        if (state === 'true') {
            $btn.text('Добавить');
            $('#dog_litter_attributes_title_input').remove();
            $btn.data('add-litter-state', 'false');
        } else {
            $btn.text('Отменить');
            $litterList.append(
                '<li class="string input optional stringish" id="dog_litter_attributes_title_input">\n' +
                '<label for="dog_litter_attributes_title" class="label">Наименование</label>\n' +
                '<input id="dog_litter_attributes_title" type="text" name="dog[litter_attributes][title]">\n' +
                '</li>'
            );
            $btn.data('add-litter-state', 'true');
        }
    }
}).call(this);