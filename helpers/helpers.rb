require 'sinatra/base'

module UserSession
  def userid
    return session[:id]
  end

  def is_anon?
    session[:id] == nil
  end

  def is_user?
    session[:id] != nil
  end

  def is_id?
    session[:id].to_i == params[:id].to_i
  end

  def login? user
    user[:password_hash] == generate_hash(params[:password], user[:password_salt])
  end

  def make_salt
    BCrypt::Engine.generate_salt
  end

  def generate_hash password, salt
    BCrypt::Engine.hash_secret(password, salt)
  end

  def set_flash message
    session[:flash_message] = message
  end

  def get_flash
    message = session[:flash_message]
    session[:flash_message] = nil
    message
  end
end

helpers UserSession
