# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  $("#petition-modal").on("ajax:success", (e, data, status, xhr) ->
  	console.log "funciono remotamente NO ERROR"
  	$('#petition-modal').foundation('reveal', 'close')
  	$('#first-modal').foundation('reveal', 'open') 
  ).on( "ajax:error", (e, xhr, status, error) ->
  	console.log "funciono remotamente ERROR"
  	$('#petition-modal').foundation('reveal', 'close')
  	$('#first-modal').foundation('reveal', 'open')) 