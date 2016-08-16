class CreateContentcategories < ActiveRecord::Migration
  def change
    create_table :contentcategories do |t|
    	t.references :content
    	t.references :category
    end
  end
end
