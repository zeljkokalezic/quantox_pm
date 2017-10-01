class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  has_many :documents, dependent: :destroy
  validates :text, presence: true
end
