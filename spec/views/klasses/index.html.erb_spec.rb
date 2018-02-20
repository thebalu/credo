require 'rails_helper'

RSpec.describe "klasses/index", type: :view do
  before(:each) do
    assign(:klasses, [
      Klass.create!(),
      Klass.create!()
    ])
  end

  it "renders a list of klasses" do
    render
  end
end
