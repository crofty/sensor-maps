require 'sensor-maps/~example/coffee-script'

( ($) ->
  $.fn.runCode = ->
    this.each ->
      $this = $(this)
      eval CoffeeScript.compile $this.text()
)(jQuery)

$ ->
  $('code pre').runCode()
