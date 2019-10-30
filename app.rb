require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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

	  # user_name, phone, date_time
	@user_name = params[:username]
	@phone = params[:phone]
	@date_time = params[:datetime]
	@barber = params[:barber]


	  # запишем в файл то, что ввел клиент
	f = File.open './public/users.txt', 'a'
	f.write "User: #{@user_name}, phone: #{@phone}, date and time: #{@date_time}, barber: #{@barber}.\n"
	f.close

  erb "Thank you!\nDear #{@user_name}, we wait you at #{@date_time}"
end

post '/contact' do
    post '/contact' do 
require 'pony'
Pony.mail(
   :name => params[:name],
  :mail => params[:mail],
  :body => params[:body],
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