require 'rails_helper'

RSpec.describe "companies/show", type: :view do
  before(:each) do
    @company = assign(:company, Company.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Business Sector/)
    expect(rendered).to match(/Address Line 1/)
    expect(rendered).to match(/Address Line 2/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Zip Code/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Utility Provider/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Business Unit/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
  end
end
