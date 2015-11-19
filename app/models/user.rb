class User < ActiveRecord::Base
  has_secure_password
  has_many :checklists

  VALID_EMAIL = /\A[\w]+\.?[\w]+@[a-z\d\.]+[\w]+\.[a-z]+\z/i

  validates :email,
    presence: true,
    format: {with: VALID_EMAIL},
    uniqueness: { case_sensitive: false }

  before_save { |data| data.email = data.email.downcase }
end
