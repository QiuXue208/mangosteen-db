class FixItemColumnType2 < ActiveRecord::Migration[7.0]
  def change
    change_column :items, :tag_id, :bigint, using: 'tag_id::bigint'
  end
end
