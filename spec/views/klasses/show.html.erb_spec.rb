require 'rails_helper'

RSpec.describe "klasses/show", type: :view do
  before(:each) do
    @klass = assign(:klass, Klass.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
