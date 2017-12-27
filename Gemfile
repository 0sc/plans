
source "https://rubygems.org"

ruby "2.3.1"

gem "active_model_serializers"
gem "apipie-rails"
gem "bcrypt", "~> 3.1.7"
gem "jwt"
gem "maruku"
gem "rack-cors"
gem "rails", "~> 4.2.7"
gem "rails-api"
gem "versionist"

group :development, :test do
  gem "factory_girl_rails", "~> 4.6"
  gem "faker"
  gem "pry-nav"
  gem "rubocop", require: false
  gem "sqlite3"
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem "simplecov", require: false
end

group :development do
  gem "spring"
end

group :production do
  gem "pg"
  gem "rails_12factor"
end
