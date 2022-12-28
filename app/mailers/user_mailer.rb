class UserMailer < ApplicationMailer
  def welcome_email(code)
    @code = code
    mail(to: '1309571292@qq.com', subject: 'hi')
  end
end
