# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".pyramid input").keypress (event)->
    $(".pyramid input").each (index)->
      this.value = ""
    @value = String.fromCharCode(event.which)
    $("#turn_letter")[0].value = @value

  $(".prepend_letter input").keypress (event)->
    $("#turn_position")[0].value = "S"

  $(".append_letter input").keypress (event)->
    $("#turn_position")[0].value = "E"

  $("#submit_turn").click (event)->
    turn_form = $("#turn_form > form")
    url = turn_form.attr('action')
    auth_token = turn_form.find('[name=authenticity_token]')[0].value
    letter = $("#turn_letter")[0].value
    position = $("#turn_position")[0].value
    $.post(url+'.json',
      auth_token: turn_form.find('[name=authenticity_token]')[0].value
      letter: $("#turn_letter")[0].value
      position: $("#turn_position")[0].value
    ).done((data)->
      alert("Hooray!")
      alert(data)
      $(".prepend_letter input").attr('disabled', 'disabled')
      $(".append_letter input").attr('disabled', 'disabled')
    )