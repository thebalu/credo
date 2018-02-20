require 'rails_helper'

RSpec.describe "konfigs/index", type: :view do
  before(:each) do
    assign(:konfigs, [
      Konfig.create!(),
      Konfig.create!()
    ])
  end

  it "renders a list of konfigs" do
    render
  end
end
