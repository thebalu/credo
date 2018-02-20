require "rails_helper"

RSpec.describe KonfigsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/konfigs").to route_to("konfigs#index")
    end

    it "routes to #new" do
      expect(:get => "/konfigs/new").to route_to("konfigs#new")
    end

    it "routes to #show" do
      expect(:get => "/konfigs/1").to route_to("konfigs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/konfigs/1/edit").to route_to("konfigs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/konfigs").to route_to("konfigs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/konfigs/1").to route_to("konfigs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/konfigs/1").to route_to("konfigs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/konfigs/1").to route_to("konfigs#destroy", :id => "1")
    end

  end
end
