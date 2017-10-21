require 'rails_helper'

RSpec.describe "sites/edit", type: :view do
  before(:each) do
    @site = assign(:site, Site.create!(
      :organization_id => 1,
      :peoperty_number => "MyString",
      :propoerty_name => "MyString",
      :type => "",
      :address_line => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip_code => "MyString",
      :country => "MyString",
      :available_acreage => 1.5,
      :available_square_feet => 1.5,
      :tota_acreage => 1.5,
      :total_square_feet => 1.5,
      :latitude => 1.5,
      :longitude => 1.5
    ))
  end

  it "renders the edit site form" do
    render

    assert_select "form[action=?][method=?]", site_path(@site), "post" do

      assert_select "input[name=?]", "site[organization_id]"

      assert_select "input[name=?]", "site[peoperty_number]"

      assert_select "input[name=?]", "site[propoerty_name]"

      assert_select "input[name=?]", "site[type]"

      assert_select "input[name=?]", "site[address_line]"

      assert_select "input[name=?]", "site[city]"

      assert_select "input[name=?]", "site[state]"

      assert_select "input[name=?]", "site[zip_code]"

      assert_select "input[name=?]", "site[country]"

      assert_select "input[name=?]", "site[available_acreage]"

      assert_select "input[name=?]", "site[available_square_feet]"

      assert_select "input[name=?]", "site[tota_acreage]"

      assert_select "input[name=?]", "site[total_square_feet]"

      assert_select "input[name=?]", "site[latitude]"

      assert_select "input[name=?]", "site[longitude]"
    end
  end
end
