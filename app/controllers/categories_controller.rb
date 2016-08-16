class CategoriesController < ApplicationController
	before_action :esAdmin?
	
	def new
		@categoria = Category.new
	end
	
	def index
		@categorias = Category.all
	end

	def create
		categoria = Category.new(parametros_permitidos)
		if categoria.save
			flash.notice =  "La Categoria #{categoria.nombre} fue Creada Satisfactoriamente"
		else
			flash.alert =  "La Categoria #{categoria.nombre} no pudo ser Creada debido a #{categoria.errors.full_messages}"
		end
		redirect_to :back
	end

	def destroy
		categoria = Category.find(params[:id])
		categoria.destroy
		redirect_to :index
	end

	def eliminar_categorias
		@categorias = params[:select_categories]
		c = @categorias.length
		if @categorias
			borrar
			if c<2
				flash.notice =  "#{c} Categoria Eliminada"
			else
				flash.notice =  "#{c} Categorias Eliminadas"
			end
		else
			flash.alert = "No hay Categorias para Eliminar"
		end
		redirect_to :back
	end

	def borrar
		@categorias.each do |d|
			Category.delete(d.to_i)
		end
	end


	private 

	def esAdmin?
		if !current_user || current_user.administration_id < 2
			redirect_to root_path, notice: "Acceso Denegado!"
		end
	end

	def parametros_permitidos
		params.require(:category).permit(:nombre)
	end
end
