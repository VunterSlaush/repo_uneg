# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ajax:success", "form#comentarios-form", (ev,data)->
	console.log data
	$("#comentarios").prepend("	<div class=\"row collapse columns\" >
									<h5>#{data.user.nombre_usuario} (Hace un instante) </h5>
									<p>#{data.cuerpo}</p>
								</div>
								<hr>")
	$(this).find("textarea").val("")