require 'rails_helper'

RSpec.describe "sites/index", type: :view do
  before(:each) do
    assign(:sites, [
      Site.create!(
        :organization_id => 2,
        :peoperty_number => "Peoperty Number",
        :propoerty_name => "Propoerty Name",
        :type => "Type",
        :address_line => "Address Line",
        :city => "City",
        :state => "State",
        :zip_code => "Zip Code",
        :country => "Country",
        :available_acreage => 3.5,
        :available_square_feet => 4.5,
        :tota_acreage => 5.5,
        :total_square_feet => 6.5,
        :latitude => 7.5,
        :longitude => 8.5
      ),
      Site.create!(
        :organization_id => 2,
        :peoperty_number => "Peoperty Number",
        :propoerty_name => "Propoerty Name",
        :type => "Type",
        :address_line => "Address Line",
        :city => "City",
        :state => "State",
        :zip_code => "Zip Code",
        :country => "Country",
        :available_acreage => 3.5,
        :available_square_feet => 4.5,
        :tota_acreage => 5.5,
        :total_square_feet => 6.5,
        :latitude => 7.5,
        :longitude => 8.5
      )
    ])
  end

  it "renders a list of sites" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Peoperty Number".to_s, :count => 2
    assert_select "tr>td", :text => "Propoerty Name".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Address Line".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Zip Code".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => 3.5.to_s, :count => 2
    assert_select "tr>td", :text => 4.5.to_s, :count => 2
    assert_select "tr>td", :text => 5.5.to_s, :count => 2
    assert_select "tr>td", :text => 6.5.to_s, :count => 2
    assert_select "tr>td", :text => 7.5.to_s, :count => 2
    assert_select "tr>td", :text => 8.5.to_s, :count => 2
  end
end
