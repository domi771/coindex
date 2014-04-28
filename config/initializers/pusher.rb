Pusher.app_id = ENV['PUSHER_APP']
Pusher.key = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']

if ENV['PUSHER_HOST']
  Pusher.host = ENV['PUSHER_HOST']
  Pusher.port = ENV['PUSHER_PORT'].to_i
end
