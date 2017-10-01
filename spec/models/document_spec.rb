require 'rails_helper'

RSpec.describe Document, type: :model do
  it { should belong_to(:comment) }

  it { should validate_presence_of(:file_contents) }
  it { should validate_presence_of(:filename) }
end