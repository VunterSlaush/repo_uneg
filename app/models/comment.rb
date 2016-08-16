class Comment < ActiveRecord::Base
  belongs_to :content
  belongs_to :user
  validates :cuerpo, length: {minimum: 1, maximum:140, alert: "debe estar entre 1 y 140 caracteres"}
end
