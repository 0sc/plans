class Checklist < Item
  belongs_to :user
  has_many :checklist_items, foreign_key: :relationship_id
end
