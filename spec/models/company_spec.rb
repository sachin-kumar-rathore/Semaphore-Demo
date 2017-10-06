require 'rails_helper'
require 'faker'

RSpec.describe Company, type: :model do

  subject { described_class.new(name: Faker::Name.name, email: Faker::Internet.email, owner_id: Faker::Number.number, subscription_id: Faker::Number.number) }

  it 'is not valid without a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an owner' do
    subject.owner_id = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without an subscriber' do
    subject.subscription_id = nil
    expect(subject).to_not be_valid
  end

  it 'is valid with valid attributes' do
    subject.owner_id = '1'
    subject.subscription_id = '2'
    subject.name = 'Anything'
    subject.email = 'test@example.com'
    expect(subject).to be_valid
  end

end
