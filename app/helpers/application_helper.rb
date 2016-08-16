module ApplicationHelper

  def top_descargas
  	@top_descargas = Content.where(status: :true).order(cantidad_descargas: :desc)
					  .limit(5)
  end

  def top_rates
    @top_rates = Content.where(status: :true)
                        .joins("left join rates on contents.id = rates.content_id")
                        .group("contents.id, rates.content_id")
                        .select("contents.*, avg(rates.valor) as puntaje, count(rates.valor) as cuenta")
                        .order("puntaje, cuenta")
                        .limit(5)
  end

  def top_comentados
    @top_comentados = Content.select("contents.*, count(comments.id) as cantidad")
                             .where(status: :true)
                             .joins("INNER JOIN comments ON contents.id = comments.content_id")
                             .group("contents.id, contents.titulo")
                             .order("cantidad DESC")
                             .limit(5)
  end

  def categoria
    @categoria = Category.new
  end

  def petition
    if current_user && Petition.find_by(:user_id => current_user.id) 
      @petition = Petition.find_by(:user_id => current_user.id)
    else
      @petition = Petition.new
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def file_type(content)
    extension = content.original_filename
    extension = extension[extension.rindex('.')+1..extension.length].upcase
  end

  def get_extension(content)

    if File.exist?("app/assets/images/icons/#{file_type(content)}.png")
      return file_type(content)
    else
      return 'UKNOWN'
    end
  end

  def get_file_icon(content)
    return "icons/#{get_extension(content.archivo)}.png"
  end
  

end
