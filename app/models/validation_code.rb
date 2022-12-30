class ValidationCode < ApplicationRecord
  # 限制code长度
  has_secure_token :code, length: 24
  # 限制email为必填项
  validates :email, presence: true

  # 定义枚举
  enum kind: { sign_in: 0, reset_password: 1 }

  before_create :generate_code
  after_create :send_email

  # 生成随机验证码
  def generate_code
    self.code = SecureRandom.random_number.to_s[2..7]
  end

  # 发送邮件
  def send_email
    UserMailer.welcome_email(self.email).deliver
  end
end
