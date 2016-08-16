class AdministratorController < ApplicationController
	before_action :esAdmin?

	def verPeticiones
		@peticiones = Petition.paginate(page: params[:page], per_page: 1).all
	end

	def mostrar_peticion
		@peticion = Petition.find(params[:id])
	end

	def aceptar_peticion
		@peticion = Petition.find(params[:id])
		@user = @peticion.user
		@user.administration_id = 2
		@user.save
		@peticion.destroy
		redirect_to '/verPeticiones', notice:"Peticion Aceptada satisfactoriamente"
	end

	def rechazar_peticion
		@peticion = Petition.find(params[:id])
		@peticion.destroy
		redirect_to '/verPeticiones', notice:"Peticion Rechazada satisfactoriamente"
	end

	def panelAdmin
		if params[:n] == nil || params[:n].to_i < 0
			params[:n] = 10
		end
		visitas_diarias
		visitas_mensuales
		mas_puntuados
		mas_descargados
		mas_comentados
		mas_puntuados
		tipo_contenido_mas_bajado
		promedio_permanencia
		categorias_mas_descargadas
		peso_total_contenidos
	end

	def visitas_diarias

		desde = params[:Desde]
		hasta = params[:Hasta]
		if desde != ""  && hasta != "" && desde != nil && hasta != nil
			@visitas_dia = Visit.where(:fecha_entrada => desde..hasta)
							.order(:fecha_entrada)
							.group(:fecha_entrada)
							.count
		else
			@visitas_dia = Visit.order(:fecha_entrada)
							.group(:fecha_entrada)
							.count
		end
	end

	def visitas_mensuales
		if params[:MDesde] && params[:MHasta]
			desde = params[:MDesde] + '-01'
			hasta = params[:MHasta] + '-30'
		else
			desde = nil
			hasta = nil
		end
		
		if desde != ""  && hasta != "" && desde != nil && hasta != nil
			@visitas_mes = Visit.group_by_month(:fecha_entrada, format: "%b %Y", range: desde..hasta)
								.count
		else
			@visitas_mes = Visit.group_by_month(:fecha_entrada, format: "%b %Y")
								.count
		end
	end

	def mas_puntuados
		if params[:select_categories]
			@mas_puntuados = Content.select("contents.id, contents.titulo, 
											categories.id as cid, count(rates.valor) as cuenta, 
											avg(rates.valor) as prom ")
									.joins("INNER JOIN contentcategories ON 
											contentcategories.content_id = contents.id")
									.joins("INNER JOIN categories ON
											 contentcategories.category_id = categories.id")
									.joins("INNER JOIN rates on rates.content_id = contents.id")
									.where("categories.id = #{params[:select_categories]}")
									.group("contents.id,contents.titulo,categories.id")
									.order("prom DESC")
									.collect{|x| ["#{x.titulo} ID:#{x.id}",
									  				 x.prom]}
		else
			@mas_puntuados = Content.select("contents.id, contents.titulo, count(rates.valor) as cuenta, 
										avg(rates.valor) as prom ")
								.joins("INNER JOIN rates on rates.content_id = contents.id")
								.group("contents.id,contents.titulo")
								.order("prom DESC")
								.collect{|x| ["#{x.titulo} ID:#{x.id}",
								  				 x.prom]}
		end
	end

	def mas_descargados	
		@mas_descargados = Content.where("cantidad_descargas > 0")
								  .order(cantidad_descargas: :desc)
								  .limit(params[:n])
								  .collect{|x| ["#{x.titulo} ID:#{x.id}",
								  				 x.cantidad_descargas]} 
	end

	def mas_comentados
		@mas_comentados = Content.select("contents.titulo,contents.id, count(comments.id) as cantidad")
								 .joins("INNER JOIN comments ON contents.id = comments.content_id")
								 .group("contents.id, contents.titulo")
								 .order("cantidad DESC")
								 .limit(params[:n])
								 .collect{|x| ["#{x.titulo} ID:#{x.id}", x.cantidad]}
	end

	def tipo_contenido_mas_bajado
		content_lenght = Content.all.length
		@tipoContenido = Content.select("upper(reverse(substring(reverse(contents.archivo_file_name),
										0, position('.' in reverse(contents.archivo_file_name))
		 								))) AS ext, count(*) AS ct")
								.group("ext")
								.collect { |e| ["#{e.ext}:#{(e.ct*100)/content_lenght}%",e.ct]}
	end

	def promedio_permanencia
		@consulta = Visit.where("hora_salida IS NOT NULL")
						 .collect { |e| [e.hora_entrada, e.hora_salida] }

		sum = 0
		min1 = 0
		min2 = 0
		@consulta.each do |hora|
			min1 = (hora[0].hour * 60) + hora[0].min
			min2 = (hora[1].hour * 60) + hora[1].min
			if hora[0].hour > hora[1].hour
				sum = sum + (1440 - min1) + min2
			else
				sum = sum + (min2 - min1)
			end
		end
		@hora_promedio = (sum/@consulta.length)/60
		@min_sobrantes = (sum/@consulta.length) - (@hora_promedio*60)
	end
	
	def peso_total_contenidos
		@peso_total_contenidos = 0.0
		Content.all.each do |size|
			@peso_total_contenidos += (size.archivo.size / 1000000.0) 			
		end
	end

	def categorias_mas_descargadas
		@categorias_descargadas = Content.select("SUM(contents.cantidad_descargas) AS descargas,
											categories.nombre")
										 .joins("INNER JOIN contentcategories ON
										  contentcategories.content_id = contents.id")
										 .joins("INNER JOIN categories ON contentcategories.category_id = categories.id")
										 .group("categories.nombre")
										 .order("descargas DESC")
										 .limit(params[:n])
										 .collect{|x| [x.nombre, x.descargas]}
	end


  def download_backup
  	if File.exists?('app/assets/repo_uneg.rar')
    	send_file 'app/assets/repo_uneg.rar', :type=>"application/octet-stream", :x_sendfile=>true
    else
    	flash.alert="No Existe ninguna Copia de Seguridad Actualmente"
    	redirect_to :back
    end
  end


	private 

	def esAdmin?
		if !current_user || current_user.administration_id < 2
			redirect_to root_path, alert: "Acceso Denegado!"
		end
	end
end
