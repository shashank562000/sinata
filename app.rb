require 'sinatra'
require 'mysql2'
require 'sinatra/activerecord'
require 'bcrypt'
require 'pry'
require_relative 'database'
require_relative 'models/user'
require_relative 'helpers' 

enable :sessions

# Homepage
get '/' do
  erb :home
end

# Show Registration Form
get '/register' do
  erb :register
end

# Registration form submit
post '/register' do
  @user = User.new(username: params[:username], password: params[:password])

  if User.exists?(username: @user.username)
    @error_message = "User already exists."
    erb :register
  elsif @user.save
    session[:registration_success] = true
    redirect '/login'
  else
    erb :register
  end
end

#  Show Login form
get '/login' do
  registration_success = true
  erb :login, locals: { registration_success: registration_success }
end

# Login form submit
post '/login' do
  @user = User.find_by(username: params[:username])
  if @user && @user.validate_password(params[:password], @user.password)
    session[:user_id] = @user.id
    session[:login_success] = true
    redirect '/dashboard'
  else
    erb :login
  end
end

# Dashboard (protected route)
get '/dashboard' do
  if logged_in?
    erb :dashboard
  else
    redirect '/login'
  end
end 

# Logout
get '/logout' do
  session.clear
  redirect '/'
end

get '/check_session' do
  if session[:login_success]
    "Session is stored for user #{session[:login_success]}"
  else
    "Session is not stored"
  end
end
