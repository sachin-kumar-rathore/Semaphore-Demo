require 'rails_helper'
require 'faker'

RSpec.describe Site, type: :model do
  subject { described_class.new(contact_id: Faker::Number, property_number: Faker::Numeric, name: Faker::Text,
                                property_type: Faker::Text, address_line: Faker::Text, city: Faker::Text,
                                state: Faker::Text, zip_code: Faker::Text, country: Faker::Text, available_acreage: Faker::Numeric,
                                available_square_feet: Faker::Numeric, total_acreage: Faker::Numeric, total_square_feet: Faker::Numeric,
                                latitude: Faker::Numeric, longitude: Faker::Numeric, business_unit: Faker::Text) }

  it 'is not valid without a contact' do
    subject.contact_id = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an property #' do
    subject.property_number = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an property name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an address line' do
    subject.address_line = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an city' do
    subject.city = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an state' do
    subject.state = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an zip code' do
    subject.zip_code = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an country' do
    subject.country = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an available acreage' do
    subject.available_acreage = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an available square feet' do
    subject.available_square_feet = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an total acreage' do
    subject.total_acreage = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an total square feet' do
    subject.total_square_feet = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an latitude' do
    subject.latitude = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an longitude' do
    subject.longitude = nil
    expect(subject).to_not be_valid
  end

end
