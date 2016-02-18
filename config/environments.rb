configure :development do
 set :database, 'postgres://localhost/favorite_movies_dev'
 set :show_exceptions, true
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'])

 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end
