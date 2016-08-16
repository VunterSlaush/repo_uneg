class PetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_petition, only: [:update, :destroy]
  before_action :peticion_valida, only: [:new]
  before_action :no_es_moderador?, only: [:new, :create]

   respond_to :html, :js

  def create
    @petition = Petition.new(petition_params)
    @petition.user_id = current_user.id
    if @petition.save
        flash.notice = "Peticion realizada Satisfactoriamente"
      else
        flash.alert = "Peticion realizada Satisfactoriamente"
    end
    redirect_to :back
  end

  def update
      if @petition.update(petition_params)
        flash.notice = "Peticion Actualizada Satisfactoriamente"
      else
        flash.alert = "no pudo ser actualizada la peticion"
      end
      redirect_to :back
  end

  def destroy
    @petition.destroy
    redirect_to root_path
  end

  private
    def set_petition
      @petition = Petition.find(params[:id])
    end

    def petition_params
      params.require(:petition).permit(:user, :razon)
    end

    def peticion_valida
      if current_user && Petition.exists?(:user_id => current_user.id)
        redirect_to root_path, alert: "Ya realizaste una Peticion de Moderador!"
      end  
    end

    def no_es_moderador?
      if current_user.administration_id > 1
        redirect_to root_path, alert: "Acceso Denegado";
      end
    end

end
