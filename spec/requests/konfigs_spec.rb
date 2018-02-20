require 'rails_helper'

RSpec.describe "Konfigs", type: :request do
  describe "GET /konfigs" do
    it "works! (now write some real specs)" do
      get konfigs_path
      expect(response).to have_http_status(200)
    end
  end
end
