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
    $(this).attr('disabled','disabled')
    turn_form = $("#turn_form > form")
    url = turn_form.attr('action')
    $.post(url+'.json',
      auth_token: turn_form.find('[name=authenticity_token]')[0].value
      letter: $("#turn_letter")[0].value
      position: $("#turn_position")[0].value
    ).done((data)->
      alert("Turn played.")
#      alert(data[0])
#      alert(data[1])
#      alert(data[2])
#      alert(data['current_letter'])
      $("#prompt").html("Refresh your browser to check for your turn...")
      $(".prepend_letter input").attr('disabled', 'disabled')[0].value = ""
      $(".append_letter input").attr('disabled', 'disabled')[0].value = ""

    )