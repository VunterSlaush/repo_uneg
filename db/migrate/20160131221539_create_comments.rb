class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :content, index: true

      t.text :cuerpo, null: false
    end
  end
end
