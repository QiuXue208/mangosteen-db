class FixItemColumnType < ActiveRecord::Migration[7.0]
  def change
    # change tag_id to string
    change_column :items, :tag_id, :string
  end
end
