class AddGeneradoToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :creado, :datetime
  end

  def self.down
    remove_column :comments, :creado
  end
end
