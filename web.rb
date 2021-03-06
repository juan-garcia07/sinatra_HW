require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
end

class Post
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :body, Text
    property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!

get '/new' do
	erb :new
end

post '/create' do
	#replace this
	p = Post.new
	p.title = params[:post_title]
	p.body = params[:post_body]
	p.save
	redirect('/post_success')
end

get '/post_success' do
	erb :post_success 
end

get '/' do
	#load all posts
	#display them
	@title = "All posts"
	@headline = "My life in blog"
	@paragraph = "Follow me and this really bad blog plz. Follow 4 Follow."
	@posts = Post.all
	erb :index
end
