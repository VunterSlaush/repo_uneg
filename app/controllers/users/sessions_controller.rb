class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  respond_to :json
  # GET /resource/sign_in
   def new
      super
   end

  # POST /resource/sign_in
   def create
    super
    contar_visita
   end

  # DELETE /resource/sign_out
  def destroy
    add_tiempo_salida
    super
  end

  protected

  def contar_visita
    if !Visit.exists?( user_id: current_user.id, hora_salida: nil, fecha_salida: nil)
      current_user.sign_in_count+=1
      current_user.save
      @visita = Visit.new
      @visita.user_id = current_user.id
      @visita.hora_entrada = Time.now
      @visita.hora_salida = nil
      @visita.fecha_entrada = Time.now 
      @visita.save
    end
  end

  def add_tiempo_salida
    @visita_usuario = Visit.find_by user_id: current_user.id, hora_salida: nil, fecha_salida: nil
    if @visita_usuario
      @visita_usuario.hora_salida = Time.now
      @visita_usuario.fecha_salida = Time.now
      @visita_usuario.save
    end
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
