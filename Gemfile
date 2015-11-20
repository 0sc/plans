source "https://rubygems.org"

ruby "2.1.7"

gem "rails", "4.2.4"
gem "rails-api"
gem "sqlite3"
gem "bcrypt", "~> 3.1.7"
gem "jwt"
gem "active_model_serializers", github: "rails-api/active_model_serializers"

group :development, :test do
  gem "pry"
  gem "factory_girl_rails", "~> 4.0"
end

group :test do
  gem "faker"
  gem 'simplecov', :require => false
end

group :development do
  gem "spring"
end

group :production do
  gem "pg"
  gem "rails_12factor"
end
