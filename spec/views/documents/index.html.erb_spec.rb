require 'rails_helper'

RSpec.describe "documents/index", type: :view do
  before(:each) do
    assign(:documents, [
      Document.create!(
        :filename => "Filename",
        :content_type => "Content Type",
        :file_contents => ""
      ),
      Document.create!(
        :filename => "Filename",
        :content_type => "Content Type",
        :file_contents => ""
      )
    ])
  end

  it "renders a list of documents" do
    render
    assert_select "tr>td", :text => "Filename".to_s, :count => 2
    assert_select "tr>td", :text => "Content Type".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
