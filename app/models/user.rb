class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  has_one :administration
  has_many :contents
  has_many :visits
  has_many :comments
  has_many :rates

  validates :pregunta_secreta, presence: { message: " es requerida"}
  validates :respuesta_secreta, presence: { message: " es requerida"}
  validates :nombre, presence: { message: " es requerido"}
  validates :email, uniqueness: {case_sensitive: false ,message: "Este Email ya esta Registrado "}
end
