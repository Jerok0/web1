require "sequel"
require "sinatra"
class Ticketer
  def initialize
    #@DB = Sequel.sqlite("mydb.db")
    @DB = Sequel.connect("postgres://ticketer:yash@localhost/tickets")
    @tickets = @DB[:tickets]
  end

  def add name, numbers, price
    @tickets.insert(:event => name, :ntickets => numbers, :pricept => price)
  end

  def get what
    @tickets.map(what.to_sym)
  end

  def diy
    yield @tickets
  end
end

configure do
  enable :sessions
  set :session_secret, "Veronica!"
end
get "/" do
  a = Ticketer.new
  @flash = session[:flash]
  @flasht = session[:flasht]
  @events = a.diy do |i|
    i.map([:id, :event])
  end
  session[:flash] = nil
  session[:flasht] = nil
  erb :index
end

get "/sudo" do
  session[:auth] = true
  session[:flash] = "Authorized to delete content."
  session[:flasht] = :good
  redirect "/"
end

get "/desudo" do
  session[:auth] = false
  session[:flash] = "Authorization revoked."
  session[:flasht] = :good
  redirect "/"
end

get "/view/:id" do
  idd = @params[:id]
  a = Ticketer.new
  @event = a.diy {|m| m.where(:id => idd).first}
  erb :view
end

get "/add" do
  erb :addnew
end

post "/add" do
  body = @params[:body]
  ntickets = @params[:ntickets].to_i
  pricept = @params[:pricept].to_i
  a = Ticketer.new
  a.add(body, ntickets, pricept)
  session[:flash] = "Event added to database."
  session[:flasht] = :good
  redirect "/"
end

get "/delete/:id" do
  if session[:auth]
    a = Ticketer.new
    a.diy {|al| al.where(:id => @params[:id].to_i).delete}
    # session[:auth] = false
    session[:flash] = "Event deleted successfully."
    session[:flasht] = :good
    redirect "/"
  else
    session[:flash] = "You do not have enough authorization."
    session[:flasht] = :bad
    redirect "/"
  end
end

get "/viewall" do
  a = Ticketer.new
  @events = a.diy {|m| m.map([:event, :ntickets, :pricept, :id])}
  erb :viewall
end