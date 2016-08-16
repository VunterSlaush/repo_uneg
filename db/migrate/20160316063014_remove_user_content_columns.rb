class RemoveUserContentColumns < ActiveRecord::Migration
  def self.up
    remove_column :users, :nombre_usuario
    remove_column :users, :fecha_nacimiento
    remove_column :contents, :tipo
  end

  def self.down
  	add_column :users, :nombre_usuario, :text
    add_column :users, :fecha_nacimiento, :date
    add_column :contents, :tipo, :integer
  end
end
