# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.game_page_vars ?= {}

game_page_vars = window.game_page_vars

ua = navigator.userAgent.toLowerCase()
game_page_vars.is_android = ua.indexOf("android") > -1

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
  unless data['current_word']? and game_page_vars.last_word is data['current_word']
    $(".played_letters").append(data['current_word']+"<br/>")
    game_page_vars.last_word = data['current_word']
    location.reload(true)
  unless data['state']? and game_page_vars.state is data['state']
    location.reload(true)

poll_for_game_changes = () ->
  $.get(game_page_vars.game_url+'.json').always((data)->
    updateGame(data)
    setTimeout(poll_for_game_changes, 5000)
  )


$ ->
  game_page_vars.turn_form_url = $("#turn_form_url")[0].value
  game_page_vars.game_url = $("#game_url")[0].value
  game_page_vars.game_challenge_url = $("#game_challenge_url")[0].value
  game_page_vars.game_respond_to_challenge_url = $("#game_respond_to_challenge_url")[0].value
  game_page_vars.game_use_power_up_url = $("#game_use_power_up_url")[0].value
  game_page_vars.auth_token = $("#auth_token")[0].value
  game_page_vars.last_word = $("#last_word")[0].value
  game_page_vars.state = $("#state")[0].value

  if game_page_vars.is_android
    $(".pyramid input").keydown (event)->
      current_input_field = this
      $(".pyramid input").each (index)->
        this.value = "" unless this == current_input_field
    $(".pyramid input").change (event)->
      game_page_vars.turn_letter = @value
    $(".prepend_letter input").change (event)->
      game_page_vars.turn_position = "S"

    $(".append_letter input").change (event)->
      game_page_vars.turn_position = "E"
  else
    $(".pyramid input").keypress (event)->
      $(".pyramid input").each (index)->
        this.value = ""
      @value = String.fromCharCode(event.which)
      game_page_vars.turn_letter = @value
    $(".prepend_letter input").keypress (event)->
      game_page_vars.turn_position = "S"

    $(".append_letter input").keypress (event)->
      game_page_vars.turn_position = "E"

  $("#submit_turn").click (event)->
    $(this).attr('disabled','disabled')
    $("#submit_challenge").attr('disabled', 'disabled')
    $("#submit_use_power_up").attr('disabled', 'disabled')
    $(".prepend_letter input").attr('disabled', 'disabled')[0].value = ""
    $(".append_letter input").attr('disabled', 'disabled')[0].value = ""
    $("#prompt").html("Validating your entry...")
    showSpinner()

    $.post(game_page_vars.turn_form_url+'.json',
      auth_token: game_page_vars.auth_token
      letter: game_page_vars.turn_letter
      position: game_page_vars.turn_position
    ).done((data)->
      $("#prompt").html("Refresh your browser to check for your turn...")
      updateGame(data)
    ).fail((data)->
      alert("A Server Error Occured:       "+data.toString())
      location.reload()
    ).always((data)->
      hideSpinner()
    )

  $("#submit_challenge").click (event)->
    $("#prompt").html("Issuing challenge...")
    showSpinner()
    $.post(game_page_vars.game_challenge_url+'.json',
      auth_token: game_page_vars.auth_token
    ).done((data)->
      $("#prompt").html("Challenge issued. Refresh your browser to check for challenge response...")
      updateGame(data)
    ).fail((data)->
      alert("A Server Error Occured:       "+data.toString())
      location.reload()
    ).always((data)->
      hideSpinner()
    )

  $("#submit_challenge_response").click (event)->
    $("#prompt").html("Checking Challenge response...")
    showSpinner()
    $.post(game_page_vars.game_respond_to_challenge_url+'.json',
      auth_token: game_page_vars.auth_token
      challenge_response: $("#challenge_response")[0].value.toUpperCase()
    ).done((data)->
      $("#prompt").html("Refresh your browser to check for challenge results...")
      updateGame(data)
    ).fail((data)->
      alert("A Server Error Occured:       "+data.toString())
      location.reload()
    ).always((data)->
      hideSpinner()
    )

  $("#submit_use_power_up").click (event)->
    $("#prompt").html("Searching for a suitable word...")
    showSpinner()
    $.post(game_page_vars.game_use_power_up_url+'.json',
      auth_token: game_page_vars.auth_token
    ).done((data)->
      $("#prompt").html("Refresh your browser to check for your word suggestion...")
      updateGame(data)
    ).fail((data)->
      alert("A Server Error Occured:       "+data.toString())
      location.reload()
    ).always((data)->
      hideSpinner()
    )

  unless game_page_vars.state.indexOf("won") > -1
    poll_for_game_changes()