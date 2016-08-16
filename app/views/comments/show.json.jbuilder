json.id @comentario.id
json.cuerpo @comentario.cuerpo
json.user_id @comentario.user_id
json.creado @comentario.creado
json.user do
	json.nombre_usuario @comentario.user.nombre
end