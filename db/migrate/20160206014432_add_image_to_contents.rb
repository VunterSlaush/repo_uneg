class AddImageToContents < ActiveRecord::Migration
  def change
  	add_attachment :contents, :imagen
  end
end
