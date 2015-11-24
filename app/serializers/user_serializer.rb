class UserSerializer < ActiveModel::Serializer
  attributes :name, :email, :created_at, :updated_at
  #bucketlist count
end
