require 'rails_helper'

RSpec.describe "sites/show", type: :view do
  before(:each) do
    @site = assign(:site, Site.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Peoperty Number/)
    expect(rendered).to match(/Propoerty Name/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Address Line/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Zip Code/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/3.5/)
    expect(rendered).to match(/4.5/)
    expect(rendered).to match(/5.5/)
    expect(rendered).to match(/6.5/)
    expect(rendered).to match(/7.5/)
    expect(rendered).to match(/8.5/)
  end
end
