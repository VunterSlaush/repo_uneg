class Petition < ActiveRecord::Base
	belongs_to :user
	validates :razon, presence: {message: "No se puede hacer una peticion sin razon alguna"}
	validates :razon, length: {minimum: 1, maximum:300, alert: "debe estar entre 1 y 300 caracteres"}
end
