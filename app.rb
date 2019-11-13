require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  db = SQLite3::Database.new 'barbershop.db'
  db.results_as_hash = true
  return db
end

def is_barber_exists? db, name
	db.execute('select *  from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users" 
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"Username" TEXT,
			"Phone" TEXT,
			"Datestamp" TEXT,
			"Barber" TEXT,
			"Color" TEXT
		)'

	db.execute 'CREATE TABLE IF NOT EXISTS
		"Barbers" 
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"Name" TEXT
		)'
	

	seed_db db, ['Jessie Pinkman', 'Walter Wight', 'Gus Fring', 'Mike Ehrmantraut']
	db.close
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	# хеш
	hh = { 	:username => 'Ваше имя',
			:phone => 'Ваш телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into 
		Users
		(
			username,
			phone,
			datestamp,
			barber,
			color
		)
		values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

	erb "Хорошо, #{@username}, мы ждем вас #{@datetime}, к мастеру #{@barber}"
end

post '/contact' do
 
require 'pony'
Pony.mail(
  :name => params[:name],
  :mail => params[:mail],
  :to => 'bodian89@gmail.com',
  :subject => params[:name] + " has contacted you",
  :body => params[:message],
  :port => '587',
  :via => :smtp,
  :via_options => { 
    :address              => 'smtp.gmail.com', 
    :port                 => '587', 
    :enable_starttls_auto => true, 
    :user_name            => 'lumbee', 
    :password             => 'p@55w0rd', 
    :authentication       => :plain, 
    :domain               => 'localhost.localdomain'
  })
redirect '/success' 

 	c = File.open './public/contacts.txt', 'a'
  	c.write "Email: #{mail}, From #{name}, message: #{body}\n"
  	c.close

  	erb "Thank you!"
end

get '/showusers' do
	db = get_db

	@results = db.execute 'select * from users order by Id desc'

	erb :showusers
end