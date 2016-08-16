class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :user, index: true
      t.time :hora_entrada, null: false
      t.time :hora_salida, null: false
      t.date :fecha_entrada, null: false
      t.date :fecha_salida, null: false
    end
  end
end
