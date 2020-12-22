class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  USER_PERMIT = %i(name email password password_confirmation)

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true,
    length: { maximum: Settings.user.validates.name_length_max }
  validates :email, presence: true,
    length: { maximum: Settings.user.validates.email_length_max },
    format: { with: Settings.user.validates.valid_regex_email },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true,
    length: { minimum: Settings.user.validates.pass_length_min }
  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
