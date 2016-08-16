class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.references :user, index: true
      t.string :titulo, null: false
      t.text :descripcion, null: false
      t.integer :tipo, null: false
      t.date :fecha_publicacion, null: false
      t.integer :cantidad_descargas, null: false
      t.boolean :status, null: false
       
    end
  end
end
