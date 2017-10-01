class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :user_id, :deadline, :priority, :status, :project_id, :created_at, :updated_at

  attribute :deadline do
    object.deadline.try(:strftime,"%Y-%m-%d")
  end

  attribute :created_at do
    object.created_at.try(:strftime,"%Y-%m-%d")
  end
end
