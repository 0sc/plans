class User < ActiveRecord::Base
  has_secure_password
  has_many :checklists, foreign_key: :relationship_id, dependent: :destroy

  VALID_EMAIL = /\A[\w]+\.?[\w]+@[a-z\d\.]+[\w]+\.[a-z]+\z/i

  validates :name, presence: true, length: { in: 2..50 }
  validates :email,
    presence: true,
    format: {with: VALID_EMAIL},
    uniqueness: { case_sensitive: false }

  before_save { |data| data.email = data.email.downcase }
end
