class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :done, :created_at, :updated_at
end
