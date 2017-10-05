require 'rails_helper'

RSpec.describe "companies/index", type: :view do
  before(:each) do
    assign(:companies, [
      Company.create!(
        :owner_id => 2,
        :subscription_id => 3,
        :name => "Name",
        :company_number => 4,
        :business_sector => "Business Sector",
        :address_line_1 => "Address Line 1",
        :address_line_2 => "Address Line 2",
        :city => "City",
        :state => "State",
        :zip_code => "Zip Code",
        :country => "Country",
        :website => "Website",
        :email => "Email",
        :member_investor => false,
        :utility_provider => "Utility Provider",
        :notes => "MyText",
        :business_unit => "Business Unit",
        :company_establishment_year => 5,
        :years_business_located => 6
      ),
      Company.create!(
        :owner_id => 2,
        :subscription_id => 3,
        :name => "Name",
        :company_number => 4,
        :business_sector => "Business Sector",
        :address_line_1 => "Address Line 1",
        :address_line_2 => "Address Line 2",
        :city => "City",
        :state => "State",
        :zip_code => "Zip Code",
        :country => "Country",
        :website => "Website",
        :email => "Email",
        :member_investor => false,
        :utility_provider => "Utility Provider",
        :notes => "MyText",
        :business_unit => "Business Unit",
        :company_establishment_year => 5,
        :years_business_located => 6
      )
    ])
  end

  it "renders a list of companies" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Business Sector".to_s, :count => 2
    assert_select "tr>td", :text => "Address Line 1".to_s, :count => 2
    assert_select "tr>td", :text => "Address Line 2".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Zip Code".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Utility Provider".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Business Unit".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
  end
end
