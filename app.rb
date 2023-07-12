require 'sinatra'
require 'sinatra/flash'
require 'mysql2'
require 'sinatra/activerecord'
require_relative 'database'
require 'bcrypt'
require 'pry'

enable :sessions
register Sinatra::Flash

# User model
class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
  
  # Encrypt the password before saving the user
  before_save :encrypt_password
  #Validat passwoard
  def validate_password(submitted_password, encrypted_password)
    # code
    BCrypt::Password.new(encrypted_password) ==submitted_password

  end

  private
  
  def encrypt_password
    self.password = BCrypt::Password.create(password)
  end
end

# Homepage
get '/' do
  erb :home
end

# Registration form
get '/register' do
  erb :register
end

# Registration submission
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

# Login form
get '/login' do
  registration_success = true
  erb :login, locals: { registration_success: registration_success }
end

# Login submission
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

# Helper method to check if user is logged in
def logged_in?
  !session[:user_id].nil?
end

get '/check_session' do
  if session[:login_success]
    "Session is stored for user #{session[:login_success]}"
  else
    "Session is not stored"
  end
end
