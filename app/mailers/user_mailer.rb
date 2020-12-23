class UserMailer < ApplicationMailer

  def account_activation user
    @user = user
    mail to: user.email, subject: t("activation.subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("activation.reset_password")
  end
end
