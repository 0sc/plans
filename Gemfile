source "https://rubygems.org"

ruby "2.1.7"

gem "rails", "4.2.4"
gem "rails-api"
gem "bcrypt", "~> 3.1.7"
gem "jwt"
gem "active_model_serializers"
gem "apipie-rails"
gem "maruku"
gem "versionist"

group :development, :test do
  gem "sqlite3"
  gem "faker"
  gem "pry-nav"
  gem "factory_girl_rails", "~> 4.0"
  gem "rubocop", require: false
end

group :test do
  gem "simplecov", require: false
  gem "codeclimate-test-reporter", require: nil
end

group :development do
  gem "spring"
end

group :production do
  gem "pg"
  gem "rails_12factor"
end
