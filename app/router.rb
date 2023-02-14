require 'date'
require "sinatra"
require 'yaml'
require 'logger'
require 'awesome_print'
require 'json'
require 'active_support'


set :bind, '0.0.0.0'
set :public_folder, __dir__ + '/public'

config = ActiveSupport::ConfigurationFile.parse('config/database.yml')

#set :environment, :production

helpers do
  def partial (template, locals = {})
    erb(template, :layout => false, :locals => locals)
  end
end

get '/' do
  "zoom zoom"
end

post '/' do

  request.body.rewind
  request_payload = JSON.parse(request.body.read)
  puts request_payload

  if request_payload['event'] == 'endpoint.url_validation'
    content_type :json
    crc = {}
    data = request_payload['payload']['plainToken']
    digest = OpenSSL::Digest.new('sha256')
    result = OpenSSL::HMAC.hexdigest(digest, config['zoom_secret'], data)
    crc[:plainToken] = data
    crc[:encryptedToken] = result
    puts crc.to_json
    return crc.to_json
  end

  #append the payload to a file
  File.open("log/events.log", "a") do |f|
    f.puts(request_payload.to_json)
  end

  "fell through"
end

post '/pp' do
  'stuff'
end

not_found do
  status 404
  "not found"
end
