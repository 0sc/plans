class BucketlistSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_by, :errors

  has_many :items

  def created_by
    object.user.id
  end

  def attributes
    data = super
    if data[:errors].empty?
      data.delete :errors
      data["date_created"] = object.created_at.strftime("%Y-%m-%d %H:%M:%S")
      data["date_modified"] = object.updated_at.strftime("%Y-%m-%d %H:%M:%S")
    else
      data = { errors: data[:errors].full_messages }
    end
    data
  end
end
