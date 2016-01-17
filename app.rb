require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'bcrypt'

require_relative "models/user"

# Session Helpers
enable :sessions

register do
  def auth (type)
    condition do
      unless send("is_#{type}?")
        session[:flash_message] = "Access Denied"
        redirect "/"
      end
    end
  end
end

helpers do
  def userid
    return session[:id]
  end

  def is_user?
    session[:id] != nil
  end

  def is_id?
    session[:id].to_i == params[:id].to_i
  end
end

# LOGIN AND LOGOUT
get '/users/login' do
  erb :login
end

post "/users/login" do
  user = User.find_by(email: params[:email])
  if user
    if user[:password_hash] == BCrypt::Engine.hash_secret(params[:password], user[:password_salt])
      session[:id] = user[:id]
      redirect '/users'
    end
  end
  session[:flash_message] = "Invalid Username or Password."
  erb :login
end

get "/users/logout" do
  session[:id] = nil
  redirect '/'
end

# Home Directory
get '/' do
  erb :home
end

# USER ROUTES
# index
get '/users', :auth => :user do
  @users = User.all
  erb :'users/index'
end

# create
post '/users' do
  if params[:password].blank?
    session[:flash_message] = "Password can't be blank."
    redirect 'users/new'
  end

  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)

  user = User.new(:email => params[:email], :password_salt => password_salt, :password_hash => password_hash)

  if user.save
    session[:flash_message] = "User Created"
    session[:id] = User.find_by(email: params[:email]).id
    redirect '/users'
  else
    session[:flash_message] = "Email #{user.errors[:email][0]}."
    redirect 'users/new'
  end
end

#new
get '/users/new' do
  erb :'users/new'
end

#show
get '/users/:id', :auth => :id do
  @user = User.find(params[:id])
  erb :'users/show'
end

#edit
get '/users/:id/edit', :auth => :id do
  @user = User.find(params[:id])
  erb :'users/edit'
end

#update
patch '/users/:id', :auth => :id do
  user = User.find(params[:id])
  if !params[:new_password].blank?
    if params[:new_password] == params[:confirm_new_password]
      password_salt = BCrypt::Engine.generate_salt
      password_hash = BCrypt::Engine.hash_secret(params[:new_password], password_salt)
      user.update(email: params[:email], password_salt: password_salt, password_hash: password_hash)
    end
    session[:flash_message] = "Password does not match."
    redirect '/users/' << params[:id]
  end
  user.update(email: params[:email])
  redirect '/users'
end

#destroy
delete '/users/:id', :auth => :id  do
  user = User.find(params[:id])
  session[:id] = nil
  user.destroy
  redirect '/'
end
