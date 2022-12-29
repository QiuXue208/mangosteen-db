class FixItemColumnName < ActiveRecord::Migration[7.0]
  def change
    # rename tags_id to tag_id
    rename_column :items, :tags_id, :tag_id
  end
end
