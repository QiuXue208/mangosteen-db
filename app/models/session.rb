class Session
  include ActiveModel::Model
  attr_accessor :email, :code
  # email 必须存在，且为邮箱格式
  validates :email, presence: true, format: { with: /\A.+@.+\z/i }
  # code 必须存在, 长度为6位数字
  validates :code, presence: true, length: { is: 6 }, numericality: { only_integer: true }

  validate :check_validation_code

  # 看code是否是发送给email的
  def check_validation_code
    # 如果code为空，或格式不正确，不需要验证
    return if self.code.blank? || !self.code.match(/\A\d{6}\z/)
    # 存在账号code，且used_at为空时才可以登录
    canSignin = ValidationCode.exists?(email: params[:email], code: params[:code], used_at: nil)
    self.errors.add :email, 404 unless canSignin
  end
end