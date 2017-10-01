require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:project) }
  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:deadline) }
  it { should validate_presence_of(:priority) }
end