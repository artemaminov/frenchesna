# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('[data-fancybox="gallery"]').fancybox(
    afterLoad: (instance, current) ->
      pixelRatio = window.devicePixelRatio || 1
      if ( pixelRatio > 1.5 )
        current.width  = current.width  / pixelRatio
        current.height = current.height / pixelRatio
    infobar: false
    toolbar: false
    parentEl: 'body'
  )