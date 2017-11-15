require 'rails_helper'

RSpec.describe "emails/new", type: :view do
  before(:each) do
    assign(:email, Email.new())
  end

  it "renders new email form" do
    render

    assert_select "form[action=?][method=?]", emails_path, "post" do
    end
  end
end
