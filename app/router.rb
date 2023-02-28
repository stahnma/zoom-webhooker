require 'active_support'
require 'awesome_print'
require 'date'
require 'json'
require 'logger'
require "sinatra"
require 'yaml'


set :bind, '0.0.0.0'
set :public_folder, __dir__ + '/public'

config = ActiveSupport::ConfigurationFile.parse('config/config.yml')
puts "Config"
ap config
puts

#set :environment, :production

helpers do
  def partial (template, locals = {})
    erb(template, :layout => false, :locals => locals)
  end
end

get '/' do
  "This application serves not content."
end

post '/' do

  request.body.rewind
  request_payload = JSON.parse(request.body.read)

  # Drop the payload on stdout
  puts request_payload

  # log the payload to a file
  File.open("log/events.log", "a") do |f|
    f.puts(request_payload.to_json)
  end

  # Handle a validation request from zoom
  if request_payload['event'] == 'endpoint.url_validation'
    content_type :json
    crc = {}
    data = request_payload['payload']['plainToken']
    digest = OpenSSL::Digest.new('sha256')
    result = OpenSSL::HMAC.hexdigest(digest, config['zoom_secret'], data)
    crc[:plainToken] = data
    crc[:encryptedToken] = result
    return crc.to_json
  end

  # Process the paylaods
  incoming_msg = {}
  j = request_payload
  if j.has_key? 'event'
    incoming_msg[:action] = j['event']
    incoming_msg[:person] = j['payload']['object']['participant']['user_name']
    incoming_msg[:ts]     = j['event_ts']

    if incoming_msg[:action] == 'meeting.participant_left'
      msg_string = "#{incoming_msg[:person]} has left the zoom meeting."
    elsif incoming_msg[:action] == 'meeting.participant_joined'
      msg_string = "#{incoming_msg[:person]} has joined the zoom meeting."
    end

    message ='{ \"text\":\"'  + msg_string + '\" }'
    # Sending this is difficult because the slack webhook handler expects text/html but the values of some parameters are JSON strings. It's ugly.
    `curl -X POST --data-urlencode \"payload=#{message}\" \"#{config['slack_webhook_uri']}\"`
    return
  end
  "fell through -- meaning unhandled payload"
end

not_found do
  status 404
  "not found"
end
