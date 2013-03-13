# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

game_page_vars = {}

spinner_opts =
  lines: 15 # The number of lines to draw
  length: 10 # The length of each line
  width: 2 # The line thickness
  radius: 7 # The radius of the inner circle
  corners: 1 # Corner roundness (0..1)
  rotate: 0 # The rotation offset
  color: "#000" # #rgb or #rrggbb
  speed: 1 # Rounds per second
  trail: 60 # Afterglow percentage
  shadow: false # Whether to render a shadow
  hwaccel: false # Whether to use hardware acceleration
  className: "spinner" # The CSS class to assign to the spinner
  zIndex: 2e9 # The z-index (defaults to 2000000000)
  top: "auto" # Top position relative to parent in px
  left: "82" # Left position relative to parent in px

showSpinner = ()->
  target = $(".played_letters")[0]
  game_page_vars['spinner'] = new Spinner(spinner_opts) unless game_page_vars['spinner']
  game_page_vars['spinner'].spin(target)

hideSpinner = ()->
  game_page_vars['spinner'].stop()

updateGame = (data)->
  unless $("#last_word")[0].value is data['current_word']
    $(".played_letters").append(data['current_word']+"<br/>")
    $("#last_word")[0].value = data['current_word']

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
    $(".prepend_letter input").attr('disabled', 'disabled')[0].value = ""
    $(".append_letter input").attr('disabled', 'disabled')[0].value = ""
    $("#prompt").html("")
    showSpinner()
    turn_form = $("#turn_form > form")
    url = turn_form.attr('action')
    $.post(url+'.json',
      auth_token: turn_form.find('[name=authenticity_token]')[0].value
      letter: $("#turn_letter")[0].value
      position: $("#turn_position")[0].value
    ).done((data)->
      hideSpinner()
      updateGame(data)
    )