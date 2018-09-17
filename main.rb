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

bot = Discordrb::Commands::CommandBot.new token: client_secret, prefix: '!'

bot.command :report do |event, *args|
  # Load the event with what we're sending to the channel.
  report = args.first
  report_urls.each do |url|
    event << "#{url}#{report}"
  end

  # Return nil
  return
end

bot.run
