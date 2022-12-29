class AddKindToItem < ActiveRecord::Migration[7.0]
  def change
    # add kind to items
    add_column :items, :kind, :integer, default: 1, null: false
  end
end
