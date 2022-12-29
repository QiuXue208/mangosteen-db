class Item < ApplicationRecord
  # enum kind
  enum kind: { expense: 1, income: 2 }
  # tag_id kind amount happen_at can't be nil
  validates :tag_id, :kind, :amount, :happen_at, presence: true

  validate :check_tag_id_belong_to_user

  def check_tag_id_belong_to_user
    all_tag_ids = Tag.where(user_id: self.user_id).map(&:id)
    unless all_tag_ids.include?(self.tag_id)
      self.errors.add(:tag_id, "#{tag_id}不属于当前用户")
    end
  end

end
