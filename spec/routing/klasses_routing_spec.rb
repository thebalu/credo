require "rails_helper"

RSpec.describe KlassesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/klasses").to route_to("klasses#index")
    end

    it "routes to #new" do
      expect(:get => "/klasses/new").to route_to("klasses#new")
    end

    it "routes to #show" do
      expect(:get => "/klasses/1").to route_to("klasses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/klasses/1/edit").to route_to("klasses#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/klasses").to route_to("klasses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/klasses/1").to route_to("klasses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/klasses/1").to route_to("klasses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/klasses/1").to route_to("klasses#destroy", :id => "1")
    end

  end
end
