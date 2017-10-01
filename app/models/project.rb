class Project < ApplicationRecord
  belongs_to :user

  has_many :tasks, dependent: :destroy

  validates :name, :description, presence: true
end
