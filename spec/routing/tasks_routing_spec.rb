require "rails_helper"

RSpec.describe TasksController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/tasks/1").to route_to("tasks#show", :id => "1")
    end

  end
end
