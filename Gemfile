source 'https://rubygems.org'
ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
gem 'bootstrap-sass', '~> 3.3.6'
# Use postgresql as the database for Active Record
gem 'pg'
gem 'jquery-rails'
gem 'jquery-easing-rails'
# Use Puma as the app server
gem 'puma', '~> 3.7'
gem 'jquery-validation-rails'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'carrierwave'
gem 'fog-aws'
gem 'elasticsearch-model'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Devise is a flexible authentication solution for Rails based on Warden
gem 'devise'
gem 'devise-authy'
# 
gem "roo", "~> 2.7.0"
gem 'roo-xls'
gem 'authority'
gem 'jquery-ui-rails'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'
gem 'redis-rack-cache'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem "figaro"
gem 'devise_invitable', '~> 1.7.0'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails', '~> 3.4', '>= 3.4.2'
  gem 'factory_girl', '~> 4.7'
  gem 'faker', '~> 1.8', '>= 1.8.4'
  gem "letter_opener"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'pg_search', '~> 1.0', '>= 1.0.5'
gem 'will_paginate'
gem 'font-awesome-rails'
gem 'paranoia', '~> 2.2'
gem 'wicked_pdf'
gem 'pdfkit'
gem 'wkhtmltopdf-binary-edge', '~> 0.12.4.0'
gem 'highcharts-rails'
gem 'sidekiq', '~> 5.1'
gem 'exception_notification', '~> 4.2', '>= 4.2.2'
gem 'cocoon', '~> 1.2', '>= 1.2.9'
gem "audited", "~> 4.5"
gem 'tinymce-rails', '~> 4.7', '>= 4.7.2'
gem 'gretel'  # for breadcrumbs
gem 'oauth2'
gem 'microsoft_graph'
gem 'dropbox_api'