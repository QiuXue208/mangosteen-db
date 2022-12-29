class Tag < ApplicationRecord
  # name、 sign 不能为空
  validates :name, :sign, presence: true
  belongs_to :user
end
