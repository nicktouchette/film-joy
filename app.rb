require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require './config/environments'

require_relative 'models/user'
require_relative 'models/movie'
require_relative 'helpers/helpers'
require_relative 'helpers/omdbhelpers'

use Rack::Session::Cookie, :key => 'session',
                           :path => '/',
                           :expire_after => 2592000,
                           :secret => '1cfb3708b8fbf1387f902cf1c66c39ee34c3f507d5b98b25d6df37f08e92dd7816f72d2f1072cf42a0d820dae8721e104026d92715e49f6f0341e73d9dbdf15d',
                           :old_secret => 'dd938f904398f3f67d0269491f6b67328d038c8138ffb9789126d086e941d92cb47989b2355bbcf035e4f47ab0be2622f43902992d73b56b6f2aa941143f25a6'

set(:auth) do |*roles|
  condition do
    unless roles.any? {|role| send("is_#{role}?") }
      set_flash "Access Denied"
      redirect "/"
    end
  end
end

# LOGIN AND LOGOUT
get '/users/login' do
  erb :login
end

post "/users/login" do
  user = User.find_by(email: params[:email])
  if !user.blank? && login?(user)
    session[:id] = user[:id]
    redirect '/movies'
  end
  set_flash "Invalid username or password."
  redirect '/'
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
get '/users', :auth => :admin do
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
    redirect '/users/' + userid.to_s
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
      redirect '/users/' + params[:id].to_s
    end
  end
  set_flash "User updated successfully."
  user.update(email: params[:email])
  redirect '/users/' + userid.to_s
end

# destroy
delete '/users/:id', :auth => :id  do
  user = User.find(params[:id])
  session[:id] = nil
  user.destroy
  redirect '/'
end

# MOVIE ROUTES
# index
get '/movies', :auth => :user do
  @movies = Movie.order(:title).where("user_id = ?", session[:id])
  erb :'movies/index'
end

# new
get '/movies/new', :auth => :user do
  erb :'movies/new'
end

# create
post '/movies', :auth => :user do
  user = User.find(userid)
  movie = user.movies.create(params[:movie])
  set_flash "Movie added successfully."
  redirect '/movies'
end

# show
get '/movies/:id', :auth => :owner do
  @movie = Movie.find(params[:id])
  erb :'movies/show'
end

# edit
get '/movies/:id/edit', :auth => :owner do
  @movie = Movie.find(params[:id])
  erb :'movies/edit'
end

# update
patch '/movies/:id', :auth => :owner do
  movie = Movie.find(params[:id])
  movie.update(params[:movie])
  set_flash "Movie updated successfully."
  redirect '/movies/' << params[:id]
end

# destroy
delete '/movies/:id', :auth => :owner do
  movie = Movie.find(params[:id])
  movie.destroy
  set_flash "Movie deleted successfully."
  redirect '/movies'
end

# SEARCH ROUTES
get '/search', :auth => :user do
  erb :search
end

post '/search', :auth => :user do
  @results = search_title params[:movie_search]
  if @results["Response"] == "False"
    set_flash @results["Error"]
    redirect '/search'
  end
  erb :results
end

get '/search/:imdbid', :auth => :user do
  @result = get_info params[:imdbid]
  erb :profile
end

post '/search/:imdbid', :auth => :user do
  user = User.find(userid)
  result = get_info params[:imdbid]
  movie = user.movies.create(title: result["Title"], genre: result["Genre"], year: result["Year"], synopsis: result["Plot"],image: result["Poster"])
  if movie.errors.any?
    set_flash "Movie cannot be added"
  else
    set_flash "Movie added successfully."
  end
  redirect '/movies'
end
