require 'discordrb'

puts ENV['CLIENT_SECRET']

bot = Discordrb::Bot.new token: ENV['CLIENT_SECRET'], client_id: ENV['CLIENT_ID']

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.run
