require 'will_paginate/array'
class ContentsController < ApplicationController
	before_action :authenticate_user! , except: [:show, :index,:descarga]
	before_action :valida_nivel, only: [:aprobar, :destroy, :edit]

	def index
		if params[:searchbox]
			busqueda(params[:searchbox].downcase)
		else
			if current_user && current_user.administration_id > 1
				@contenido = Content.paginate(page: params[:page], per_page: 5)
			else
				@contenido = Content.where("status = true").paginate(page: params[:page], per_page: 5)
			end
		end
	end

	def busqueda(search)
		palabras = search.split(' ')
		puts palabras
		@contenido = Array.new()
		palabras.each do |palabra|
			@contenido = @contenido + ( busca_categoria(palabra) + busca_nombre_descripcion(palabra) + busca_archivo(palabra))
		end
		if !current_user || current_user.administration_id < 2
			@contenido.delete_if{ |e| e.status == false }
		end

		@contenido = @contenido.uniq.paginate(page: params[:page], per_page: 5) 
	end

	def busca_categoria(search)
		busqueda =  Content.joins("INNER JOIN contentcategories ON contentcategories.content_id = contents.id")
							 .joins("INNER JOIN categories ON categories.id = contentcategories.category_id")
							 .where("LOWER(categories.nombre) LIKE ? AND status = true", "%#{search}%" )
		return busqueda
	end

	def busca_nombre_descripcion(search)
		busqueda = Content.where("LOWER(titulo) LIKE ? OR 
								  LOWER(descripcion) LIKE ? AND status = true",
								 "%#{search}%", "%#{search}%")
		return busqueda
	end

	def busca_archivo(search)
		busqueda = Content.where("LOWER(archivo_file_name) LIKE ? AND status = true", "%#{search}%")
		return busqueda
	end
		
	def new
		@contenido = Content.new
	end

	def edit
		@contenido = Content.find(params[:id])
	end

	def update
		@contenido = Content.find(params[:id])
		borrar_categorias
		guardar_categorias
		if @contenido.update(parametros_permitidos)
			redirect_to @contenido
		else
			render :edit
		end
	end

	def show
		@contenido = Content.find(params[:id])
		@comentario = Comment.new
		@puntaje = Rate.new
		peso_archivo
		contenido_relacionado
	end

	def peso_archivo
		if @contenido.archivo.size > 1000000
			peso = @contenido.archivo.size/1000000
			@peso_archivo = "#{peso} MB"
		else
			peso = @contenido.archivo.size/1000
			@peso_archivo = "#{peso} KB" 
		end
	end

	def descarga
		@contenido = Content.find(params[:id])
		@contenido.cantidad_descargas+=1
		if @contenido.save
			redirect_to @contenido.archivo.url()
		end
	end

	def create
		@contenido = Content.new(parametros_permitidos)
		@contenido.user_id = current_user.id
		@contenido.fecha_publicacion = Time.now
		guardar_categorias
		if @contenido.user.administration_id < 2
			@contenido.status = false
		else
			@contenido.status = true
		end

		if @contenido.save
			redirect_to @contenido  
		else
			render :new
		end
	end

	def guardar_categorias
		params[:content][:contentcategories].each do |categorie|
			if categorie != ""
				@contenido.contentcategories.new(:category_id => categorie.to_i)
			end
		end
	end

	def borrar_categorias
		@contenido.contentcategories.each do |c|
			c.destroy
		end
	end
	
	def destroy
		@contenido = Content.find(params[:id])
		@contenido.archivo.clear
		@contenido.imagen.clear
		
		rates = @contenido.rates
		
		comentarios = @contenido.comments
		
		comentarios.each do |com|
			com.destroy
		end
		rates.each do |sc|
			sc.destroy
		end
		borrar_categorias
		@contenido.destroy
		redirect_to contents_path, notice: "Contenido #{@contenido.titulo} Eliminado"
	end

	def aprobar
		@contenido = Content.find(params[:id])
		@contenido.status = true
		if @contenido.save
			redirect_to :back, notice: "Contenido #{@contenido.titulo} Aprobado!"
		end
	end

	def contenido_relacionado
		@contenido_relacionado = Array.new() 
		@contenido.contentcategories.each do |categorie|
			id_contenidos = Contentcategory.where(:category_id => categorie.category_id)
			if Contentcategory.where(:category_id => categorie.category_id).count > 1
				id_contenidos.each do |c|
					if Content.find(c.content_id).status
						@contenido_relacionado.push(Content.find(c.content_id))
					end
				end
			end
		end

		Content.where("LOWER(titulo) LIKE ? OR LOWER(descripcion) LIKE ? AND status = true",
		 "%#{@contenido.titulo}%", "%#{@contenido.titulo}%" ).each do |content|
		 	@contenido_relacionado.push(content)
		 end

		Content.where("UPPER(contents.archivo_file_name) LIKE ?", 
					  "%#{get_extension(@contenido.archivo)}%").each do |content|
		 	@contenido_relacionado.push(content)
		 end

		 @contenido_relacionado.delete_if { |e| e.id == @contenido.id }
		 @contenido_relacionado = @contenido_relacionado.uniq

	end

  def get_extension(content)
    extension = content.original_filename
    extension = extension[extension.rindex('.')+1..extension.length].upcase
    return extension
  end


	private 

	def valida_nivel
		if !current_user || current_user.administration_id == 1
			redirect_to root_path, notice: "No Posees permisos para acceder!"
		end
	end

	def parametros_permitidos
		params.require(:content).permit(:titulo,:descripcion,:imagen, :archivo,:contentcategories)
	end
end
