class Category < ActiveRecord::Base
	has_many :contentcategories

	validates :nombre, presence: {message: "Es Obligatorio"}, uniqueness: {message: "Ya Existe"}
	validates :nombre, length: {minimum: 5, maximum:40, message: "debe estar entre 5 y 40 caracteres"}
end
