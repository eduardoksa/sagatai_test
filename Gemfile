source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem 'jwt'
gem 'bcrypt', '~> 3.1.7'
gem 'sidekiq'
gem 'cpf_cnpj'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem 'rspec-rails'
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem 'faker'
  gem 'factory_bot_rails'
end

group :development do
end

group :test do
end
