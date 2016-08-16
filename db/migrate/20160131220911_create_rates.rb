class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.references :user, null: false
      t.references :content, null: false
      t.float :valor, null: false
    end
  end
end
