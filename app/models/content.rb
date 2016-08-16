class UserLevelSizeValidator < ActiveModel::Validator
  
  def validate(record)
    if !record.archivo.blank? && record.archivo.size > 100.megabytes && record.user.administration_id < 2
      	record.errors[:archivo] << 'No puede subir un archivo de mas de 100Mb'
    end
  end
end



class Content < ActiveRecord::Base

  belongs_to :user
  has_many :comments
  has_many :rates
  has_many :contentcategories

  has_attached_file :imagen, styles: {medium: "650x350", thumb: "650x350" }
  has_attached_file :archivo


  validates :titulo, presence:{ message: " es requerido"}, length: {minimum: 1, maximum:60, message: "debe tener como maximo 40 caracteres"}
  validates :descripcion, presence:{ message: " es requerida"}, length: {minimum: 10, maximum:500, message: "debe tener entre 10 y 500 caracteres"}
  validates :imagen, presence: { message: " es requerida"}
  validates :archivo, presence: { message: " es requerido"}

  
  validates_attachment_content_type :imagen, content_type: /\Aimage\/.*\Z/

  validates_attachment_content_type :archivo, content_type: /.*/ 

  validates_attachment_size :imagen, :in => 0.megabytes..3.megabytes, message: "La imagen del Contenido no puede pesar mas de 3Mb"

  validates_with UserLevelSizeValidator
end
