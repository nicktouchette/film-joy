# FilmJoy
A favorite movie database created with Sinatra.  Complete with multi-user support.

## Gems Used
- Sinatra
- Sinatra-activerecord (extends rake tasks to Sinatra)
- Postgresql
- ActiveRecord
- Rake
- Bcrypt

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
