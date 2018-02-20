require 'rails_helper'

RSpec.describe "konfigs/edit", type: :view do
  before(:each) do
    @konfig = assign(:konfig, Konfig.create!())
  end

  it "renders the edit konfig form" do
    render

    assert_select "form[action=?][method=?]", konfig_path(@konfig), "post" do
    end
  end
end
