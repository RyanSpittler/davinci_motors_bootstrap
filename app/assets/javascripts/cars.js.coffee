# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.pagination a', ->
  $(".cars").hide()
  $(".cars_loading").show()
  $.getScript @href
  false
