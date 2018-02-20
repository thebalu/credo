require 'rails_helper'

RSpec.describe "konfigs/new", type: :view do
  before(:each) do
    assign(:konfig, Konfig.new())
  end

  it "renders new konfig form" do
    render

    assert_select "form[action=?][method=?]", konfigs_path, "post" do
    end
  end
end
