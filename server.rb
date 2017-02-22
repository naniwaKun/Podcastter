require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'slim/include'
require 'json'
require_relative "./src/update.rb"
require_relative "./src/tm.rb"

File.open( File.expand_path(File.dirname($0)) + "/etc/config.json") do |file|
  $set = JSON.load(file)
end
$set["baseDir"] =  File.expand_path(File.dirname($0)) + "/"

get '/' do
	send_file File.join('./public/post/', 'index.html')
end

get '/management/update' do
  up = Update.new
  up.makeWeb($set)
  "finish"
end

post '/management/tweet' do
  if params[:description]
    twi = Twimane.new
    retUrl = twi.tweet(params[:description],$set)
    retUrl
  else
    "つぶやけなかった！"
  end
end

post '/management/upload' do
	if params[:mp3file]
		savePath = $set["baseDir"] + "public/episode/#{params[:mp3file][:filename]}" 
    File::open(savePath, "a").write( params[:mp3file][:tempfile].read)
		"$set["baseUrl"] + "public/episode/#{params[:mp3file][:filename]} + "\n"
	else
		"アップロード失敗"
	end
end

not_found do
	"404 Error !!"
end
