class AddAdministrationIdToUser < ActiveRecord::Migration
  def change
    add_reference :users, :administration, index: true
  end
end
