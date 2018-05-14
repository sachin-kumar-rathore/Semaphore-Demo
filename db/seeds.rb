# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

# Transactional Emails
TransactionalEmail::TYPES.each do |type|
  unless TransactionalEmail.find_by_type_id(type[:type_id])
    TransactionalEmail.create!(name: type[:name], body: Faker::Lorem.paragraph, type_id: type[:type_id], subject: type[:name])
  end
end

# System Modules and Default Package
GeneralModule.create(Constant::GENERAL_MODULES)
GeneralModule.create(Constant::CUSTOM_MODULES.merge(is_custom: true))

default_modules = GeneralModule.default_modules
default_package = Package.create(name: 'default-standard')
default_modules.map{ |default_module| default_package.package_modules.create(general_module_id: default_module.id) }

# Section's information
Constant::SECTIONS.each do |section_name|
  SectionGuide.create(section_name: section_name, section_info: Faker::Lorem.paragraph)
end