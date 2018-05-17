# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'


# Transactional Emails
TransactionalEmail.destroy_all if TransactionalEmail.count > 0
Constant::EMAIL_TYPES.each do |type|
  TransactionalEmail.create!(name: type[:name], body: Faker::Lorem.paragraph, type_id: type[:type_id],
                             subject: type[:name], recipient_roles: type[:recipient_roles])
end
# Transactional Email's categories
TransactionalEmail.where(type_id: [1, 2]).update(category_id: TransactionalEmail.find_by(type_id: 19).id)
TransactionalEmail.where(type_id: [3, 4]).update(category_id: TransactionalEmail.find_by(type_id: 18).id)
TransactionalEmail.where(type_id: [5, 6, 7]).update(category_id: TransactionalEmail.find_by(type_id: 17).id)
TransactionalEmail.where(type_id: [10, 11, 13]).update(category_id: TransactionalEmail.find_by(type_id: 16).id)
TransactionalEmail.where(type_id: [8, 9, 12]).update(category_id: TransactionalEmail.find_by(type_id: 15).id)
TransactionalEmail.where(type_id: [15, 16]).update(category_id: TransactionalEmail.find_by(type_id: 14).id)
# Keep body field empty for categories and subcategories
TransactionalEmail.where(type_id: [14, 15, 16, 17, 18, 19]).each do |email|
  email.attributes = {body: nil}
  email.save(validate: false)
end

# System Modules and Default Package
GeneralModule.destroy_all if GeneralModule.count > 0
GeneralModule.create!(Constant::GENERAL_MODULES)
GeneralModule.create!(Constant::CUSTOM_MODULES.map { |m| m.merge(is_custom: true) })

Package.destroy_all if Package.count > 0
default_modules = GeneralModule.default_modules
default_package = Package.create!(name: 'default-standard')
default_modules.map{ |default_module| default_package.package_modules.create(general_module_id: default_module.id) }


# Section's information
SectionGuide.destroy_all if SectionGuide.count > 0
Constant::SECTIONS.each do |section_name|
  SectionGuide.create!(section_name: section_name, section_info: Faker::Lorem.paragraph)
end

# SuperAdmin
Admin.destroy_all if Admin.count > 0
Admin.create!(email: 'superadmin@example.com', password: '12345678', password_confirmation: '12345678')

# First Organization
Organization.destroy_all if Organization.count > 0
Organization.create!(name: 'Test Organization', url: 'testorg.com', primary_contact_first_name: Faker::Name.first_name , 
                     primary_contact_last_name: Faker::Name.last_name, primary_contact_phone: Faker::PhoneNumber.phone_number, 
                     primary_contact_email: "admin@example.com")

# First User
User.destroy_all if User.count > 0
User.create!(email: 'admin@example.com', password: '12345678', password_confirmation: '12345678',
             first_name: Faker::Name.first_name , last_name: Faker::Name.last_name, organization_id: Organization.first.id)
