require 'sinatra/base'

module UserSession
  def userid
    return session[:id]
  end

  def username
    if userid
      User.find(userid).email
    end
  end

  def is_owner?
    Movie.find(params[:id]).user_id == userid
  end

  def is_anon?
    session[:id].blank?
  end

  def is_user?
    !session[:id].blank?
  end

  def is_id?
    session[:id].to_i == params[:id].to_i
  end

  def is_admin?
    session[:id].to_i == 1
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
