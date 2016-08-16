class AddFileToContent < ActiveRecord::Migration
  def change
  	add_attachment :contents, :archivo
  end
end
