class UserExtraController < ApplicationController

	def nueva_clave
	end

	def crear_clave
		definir_user
	    if @user == nil
	      redirect_to '/new_password', alert:"Email Invalido #{params[:email].downcase}"
	    end
	end
	
	def cambiar_clave
		definir_user
		if params[:respuesta]
			if Digest::MD5.hexdigest(params[:respuesta].downcase) != @user.respuesta_secreta
				redirect_to '/new_password', alert: "Respuesta invalida: #{params[:respuesta]}"
			end
		end
	end

	def change_pass
		definir_user
		if params[:pass] == params[:confirm_pass] 
			if params[:pass].length >= 8
				@user.password = params[:pass]
				if @user.save
					redirect_to root_path, notice: "Contraseña Cambiada Satisfactoriamente"
				else
					redirect_to root_path, alert: "La contraseña no pudo ser cambiada"
				end
			else
				redirect_to  root_path, alert: "La contraseña no pudo ser cambiada"
			end
		else
			redirect_to  root_path, alert: "La contraseña no pudo ser cambiada"
		end

	end

	def definir_user
		@user = User.find_by(:email => params[:email].downcase)
	end	
end
