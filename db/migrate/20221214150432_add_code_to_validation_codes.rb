class AddCodeToValidationCodes < ActiveRecord::Migration[7.0]
  def change
    add_column :validation_codes, :code, :integer
  end
end
