require 'discordrb'
require 'yaml'

configs = FileTest.exist?('config.yaml') ? YAML.load_file('config.yaml') : {}
client_secret = configs['client_secret'] || ENV['CLIENT_SECRET']
client_id = configs['client_id'] || ENV['CLIENT_ID']

WARCRAFTLOGS = "https://www.warcraftlogs.com/reports/"
WOWANALIZER = "https://wowanalyzer.com/report/"
WIPEFEST = "https://www.wipefest.net/report/"

report_urls = [
  WARCRAFTLOGS,
  WOWANALIZER,
  WIPEFEST,
]

# bot = Discordrb::Commands::CommandBot.new token: client_secret, prefix: '!'

# bot.command :report do |event, *args|
#   # Load the event with what we're sending to the channel.
#   report = args.first
#   report_urls.each do |url|
#     event << "#{url}#{report}"
#   end

#   # Return nil
#   return
# end

# bot.run

botCapture = Discordrb::Bot.new token: client_secret

botCapture.message() do |event|
  print "#{event.message.to_s}\n"
  # print "#{event.username}\n"
  username = event.user.username;
  message = event.message;

  if username == "Warcraft Logs" then
    parts = message.to_s.split("\n")
    urlParts =  parts[1].split("/");

    # Load the event with what we're sending to the channel.
    i = -1;
    urlParts.each_with_index do |part, index|
      if part == 'reports' then
        i = index;
        break;
      end
    end

    # The response we'll send to the server.
    result = [];
    result << "\n**[#{parts.last}]**\n\n"

    # Get the actual report.
    report = urlParts[i + 1]
    report_urls.each do |url|
      result << "#{url}#{report}"
    end

    # Send the response back to the server.
    event.respond result.join("\n")
  end
end

botCapture.run
