class AddPhotosCountToUsers2 < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :photos_count
    add_column :users, :photos_count, :integer, default: 0
  end
end
