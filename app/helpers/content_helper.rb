module ContentHelper
	def aprobar(contenido)
		contenido.status = true
		contenido.save
	end
end
