class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :done, :date_created, :date_modified

  def date_created
    object.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def date_modified
    object.updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end
