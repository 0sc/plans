class Item < List
  belongs_to :bucketlist, foreign_key: :relationship_id
end
