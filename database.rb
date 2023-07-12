require 'sinatra/activerecord'

# Database configuration
configure :development do
    set :database, {
      adapter: 'mysql2',
      database: 'ecom',
      username: 'root',
      password: 'Shasha@123&',
      host: 'localhost',
      port: 3306,
      pool: 5,
      timeout: 5000
    }
  end
