require 'rails_helper'

RSpec.describe "konfigs/show", type: :view do
  before(:each) do
    @konfig = assign(:konfig, Konfig.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
