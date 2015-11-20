class Item < List
  belongs_to :checklist, foreign_key: :relationship_id
end
