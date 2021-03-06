require 'rails_helper'

RSpec.describe "cars/index", type: :view do
  before(:each) do
    controller.singleton_class.class_eval do
      protected
      def current_user
        FactoryGirl.build_stubbed(:user)
      end
      helper_method :current_user
    end
    assign(:cars, [
      Car.create!(
        :make => "Chevrolet",
        :model => "Cavalier",
        :year => 1999,
        :price => "9.99"
      ),
      Car.create!(
        :make => "Chevrolet",
        :model => "Cavalier",
        :year => 1999,
        :price => "9.99"
      )
    ])
  end

  it "renders a list of cars" do
    allow(view).to receive_messages(:will_paginate => nil)
    render
    assert_select "tr>td", :text => "Chevrolet".to_s, :count => 2
    assert_select "tr>td", :text => "Cavalier".to_s, :count => 2
    assert_select "tr>td", :text => 1999.to_s, :count => 2
    assert_select "tr>td", :text => "$9.99".to_s, :count => 2
  end
end
