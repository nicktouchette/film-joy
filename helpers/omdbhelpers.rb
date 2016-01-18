require 'sinatra/base'
require 'net/http'
require 'json'

module OmdbHelpers
  @@omdb_root = omdb_root = "http://www.omdbapi.com/?"
  def search_title search
    url = URI.escape(@@omdb_root << "s=" << search)
    uri = URI(url)
    response = Net::HTTP.get(uri)
    return JSON.parse(response)
    # return {"Search"=>[{"Title"=>"Johnny Test", "Year"=>"2005–", "imdbID"=>"tt0454349", "Type"=>"series", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BMTk5NjMyMTc5NF5BMl5BanBnXkFtZTcwNTI5ODAwMw@@._V1_SX300.jpg"}, {"Title"=>"Test Pilot", "Year"=>"1938", "imdbID"=>"tt0030848", "Type"=>"movie", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BODMwNzkyNDg3OV5BMl5BanBnXkFtZTgwMDU2NjQzMTE@._V1_SX300.jpg"}, {"Title"=>"Test", "Year"=>"2013", "imdbID"=>"tt2407380", "Type"=>"movie", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BMTQwMDU5NDkxNF5BMl5BanBnXkFtZTcwMjk5OTk4OQ@@._V1_SX300.jpg"}, {"Title"=>"The Test", "Year"=>"2012", "imdbID"=>"tt1986180", "Type"=>"movie", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BMTYwNTgzMjM5M15BMl5BanBnXkFtZTcwNDUzMTE1OA@@._V1_SX300.jpg"}, {"Title"=>"Baka and Test: Summon the Beasts", "Year"=>"2010–", "imdbID"=>"tt1655610", "Type"=>"series", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BOTE0NTc1MzE5OV5BMl5BanBnXkFtZTgwNTMyMTgwMzE@._V1_SX300.jpg"}, {"Title"=>"Rabbit Test", "Year"=>"1978", "imdbID"=>"tt0078133", "Type"=>"movie", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BMTI1MDEwNDI5Ml5BMl5BanBnXkFtZTYwNTQ1Mjg5._V1_SX300.jpg"}, {"Title"=>"This Is Not a Test", "Year"=>"1962", "imdbID"=>"tt0183884", "Type"=>"movie", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BOTU5MDkwNDAzOV5BMl5BanBnXkFtZTgwNjE4NDgwMzE@._V1._CR76,175,222,296_SY132_CR5,0,89,132_AL_.jpg_V1_SX300.jpg"}, {"Title"=>"Sound Test for Blackmail", "Year"=>"1929", "imdbID"=>"tt0249159", "Type"=>"movie", "Poster"=>"N/A"}, {"Title"=>"The Tree in a Test Tube", "Year"=>"1943", "imdbID"=>"tt0036455", "Type"=>"movie", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BMTQ4MTM5MDY2MV5BMl5BanBnXkFtZTcwNjEwMjIyMQ@@._V1_SX300.jpg"}, {"Title"=>"3 Day Test", "Year"=>"2012", "imdbID"=>"tt2184095", "Type"=>"movie", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BMTQwNzEwMzk3MF5BMl5BanBnXkFtZTcwOTkzMTUyOQ@@._V1_SX300.jpg"}]}
  end

  def get_info imdbid
    url = (@@omdb_root << "i=" << imdbid).to_s
    uri = URI(url)
    response = Net::HTTP.get(uri)
    return JSON.parse(response)
    # return {"Title"=>"Napoleon Dynamite", "Year"=>"2004", "Rated"=>"PG", "Released"=>"27 Aug 2004", "Runtime"=>"96 min", "Genre"=>"Comedy", "Director"=>"Jared Hess", "Writer"=>"Jared Hess, Jerusha Hess", "Actors"=>"Jon Heder, Jon Gries, Aaron Ruell, Efren Ramirez", "Plot"=>"A listless and alienated teenager decides to help his new friend win the class presidency in their small western high school, while he must deal with his bizarre family life back home.", "Language"=>"English", "Country"=>"USA", "Awards"=>"10 wins & 18 nominations.", "Poster"=>"http://ia.media-imdb.com/images/M/MV5BNjYwNTA3MDIyMl5BMl5BanBnXkFtZTYwMjIxNjA3._V1_SX300.jpg", "Metascore"=>"64", "imdbRating"=>"6.9", "imdbVotes"=>"154,227", "imdbID"=>"tt0374900", "Type"=>"movie", "Response"=>"True"}
  end

end

helpers OmdbHelpers
