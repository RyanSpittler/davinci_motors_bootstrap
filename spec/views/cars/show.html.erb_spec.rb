require 'rails_helper'

RSpec.describe "cars/show", type: :view do
  before(:each) do
    @car = assign(:car, Car.create!(
      :make => "Chevrolet",
      :model => "Cavalier",
      :year => 1999,
      :price => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Chevrolet/)
    expect(rendered).to match(/Cavalier/)
    expect(rendered).to match(/1999/)
    expect(rendered).to match(/9.99/)
  end
end
