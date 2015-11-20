class Item < List
  validates :name,
    presence: true,
    length: { in: 2..50 },
    uniqueness: { case_sensitive: false }

  belongs_to :checklist
end
