class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :filename, :content_type, :created_at, :size

  attribute :created_at do
    object.created_at.try(:strftime,"%Y-%m-%d")
  end

  attribute :size do
    (object.size || 0) > 0 ? ::ApplicationController.helpers.number_to_human_size(object.size) : "---"
  end
end
