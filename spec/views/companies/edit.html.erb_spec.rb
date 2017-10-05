require 'rails_helper'

RSpec.describe "companies/edit", type: :view do
  before(:each) do
    @company = assign(:company, Company.create!(
      :owner_id => 1,
      :subscription_id => 1,
      :name => "MyString",
      :company_number => 1,
      :business_sector => "MyString",
      :address_line_1 => "MyString",
      :address_line_2 => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip_code => "MyString",
      :country => "MyString",
      :website => "MyString",
      :email => "MyString",
      :member_investor => false,
      :utility_provider => "MyString",
      :notes => "MyText",
      :business_unit => "MyString",
      :company_establishment_year => 1,
      :years_business_located => 1
    ))
  end

  it "renders the edit company form" do
    render

    assert_select "form[action=?][method=?]", company_path(@company), "post" do

      assert_select "input[name=?]", "company[owner_id]"

      assert_select "input[name=?]", "company[subscription_id]"

      assert_select "input[name=?]", "company[name]"

      assert_select "input[name=?]", "company[company_number]"

      assert_select "input[name=?]", "company[business_sector]"

      assert_select "input[name=?]", "company[address_line_1]"

      assert_select "input[name=?]", "company[address_line_2]"

      assert_select "input[name=?]", "company[city]"

      assert_select "input[name=?]", "company[state]"

      assert_select "input[name=?]", "company[zip_code]"

      assert_select "input[name=?]", "company[country]"

      assert_select "input[name=?]", "company[website]"

      assert_select "input[name=?]", "company[email]"

      assert_select "input[name=?]", "company[member_investor]"

      assert_select "input[name=?]", "company[utility_provider]"

      assert_select "textarea[name=?]", "company[notes]"

      assert_select "input[name=?]", "company[business_unit]"

      assert_select "input[name=?]", "company[company_establishment_year]"

      assert_select "input[name=?]", "company[years_business_located]"
    end
  end
end
