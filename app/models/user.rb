class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true,
    length: { maximum: Settings.user.validates.name_length_max }
  validates :email, presence: true,
    length: { maximum: Settings.user.validates.email_length_max },
    format: { with: Settings.user.validates.valid_regex_email },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true,
    length: { minimum: Settings.user.validates.pass_length_min }
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
