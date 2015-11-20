class Checklist < List
  belongs_to :user, foreign_key: :relationship_id
  has_many :items, foreign_key: :relationship_id, dependent: :destroy

  def pending
    items.where(done: false)
  end

  def completed
    items.where(done: true)
  end
end
