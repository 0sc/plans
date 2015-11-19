class Checklist < ActiveRecord::Base

  validates :name,
    presence: true,
    length: { in: 2..50 },
    uniqueness: { case_sensitive: false }

  belongs_to :user
  has_many :checklist_items
end
