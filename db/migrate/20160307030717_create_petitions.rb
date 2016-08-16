class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
      t.references :user
      t.text :razon
	end
  end
end
