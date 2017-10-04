require 'rails_helper'
require 'faker'

RSpec.describe Contact, type: :model do

  subject { described_class.new(name: Faker::Name.first_name, email: Faker::Internet.email) }
  
  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without an email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

end

