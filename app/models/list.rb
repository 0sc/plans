class List < ActiveRecord::Base
  validates :name,
    presence: true,
    length: { in: 2..50 },
    uniqueness: { case_sensitive: false }
end
