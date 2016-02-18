# FilmJoy
A favorite movie database created with Sinatra.  Complete with multi-user support.

Link:
[Film Joy](http://film-joy.herokuapp.com)

## Technology Used
- Sinatra
- Sinatra-activerecord (extends rake tasks to Sinatra)
- ActiveRecord
- Postgresql
- Rake
- Bcrypt
- Bootstrap

## How to use

Clone the repository and cd into the directory.

```
bundle install
```
Will install all gems necessary to run the app.

```
rake db:create
```
Create a postgresql database.  Be sure to have a postgresql server running before initiating this command.

```
rake db:migrate
```
Add's all tables according to migration files.

```
ruby app.rb
```
The ruby server will start, and the app can be located at localhost:4567, if the port was left to default.

## Summary

The authZ/authN was coded from the ground up.  Password encryption + salting was achieved with Bcrypt.  ActiveRecord migrations were used in conjunction with Sinatra.  Bootstrap was used for the styling.

