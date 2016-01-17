require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'

require_relative 'models/user'
require_relative 'helpers/helpers'

# Session Helpers
enable :sessions
set :session_secret, 'super secret'

register do
  def auth (type)
    condition do
      unless send("is_#{type}?")
        set_flash "Access Denied"
        redirect "/"
      end
    end
  end
end

# LOGIN AND LOGOUT
get '/users/login' do
  erb :login
end

post "/users/login" do
  user = User.find_by(email: params[:email])
  if login?(user)
    session[:id] = user[:id]
    redirect '/users'
  end
  set_flash "Invalid username or password."
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
post '/users', :auth => :anon do
  if params[:password].blank?
    set_flash "Password can't be blank."
    redirect 'users/new'
  end

  salt = make_salt
  user = User.new(:email => params[:email], :password_salt => salt, :password_hash => generate_hash(params[:password], salt))

  if user.save
    set_flash "User Created"
    session[:id] = User.find_by(email: params[:email]).id
    redirect '/users'
  else
    set_flash "Email #{user.errors[:email][0]}."
    redirect 'users/new'
  end
end

# new
get '/users/new', :auth => :anon do
  erb :'users/new'
end

# show
get '/users/:id', :auth => :id do
  @user = User.find(params[:id])
  erb :'users/show'
end

# edit
get '/users/:id/edit', :auth => :id do
  @user = User.find(params[:id])
  erb :'users/edit'
end

# update
patch '/users/:id', :auth => :id do
  user = User.find(params[:id])
  if !params[:new_password].blank?
    if params[:new_password].to_s == params[:confirm_new_password].to_s
      salt = make_salt
      user.update(email: params[:email], password_salt: salt, password_hash: generate_hash(params[:new_password], salt))
    else
      set_flash "Password does not match."
      redirect '/users/' << params[:id]
    end
  end
  set_flash "User updated successfully."
  user.update(email: params[:email])
  redirect '/users'
end

# destroy
delete '/users/:id', :auth => :id  do
  user = User.find(params[:id])
  session[:id] = nil
  user.destroy
  redirect '/'
end
