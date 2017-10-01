class Task < ApplicationRecord
  belongs_to :user
  belongs_to :project

  has_many :comments

  enum priority: [ :P0, :P1, :P2, :P3 ]
  enum status: [ :done, :in_progress, :not_started, :stalled ]
end
