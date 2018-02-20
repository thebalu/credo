require 'rails_helper'

RSpec.describe "Klasses", type: :request do
  describe "GET /klasses" do
    it "works! (now write some real specs)" do
      get klasses_path
      expect(response).to have_http_status(200)
    end
  end
end
