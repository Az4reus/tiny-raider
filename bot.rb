require 'discordrb'
require 'net/http'
require 'json'

RAIDER_IO_ROOT = 'https://raider.io/api/v1/'.freeze
DESIRED_RIO_FIELDS = 'mythic_plus_scores,'\
    'gear,'\
    'guild,'\
    'mythic_plus_recent_runs'.freeze

if ARGV[0].nil?
  p 'No Token specified!'
  exit 1
end
TOKEN = ARGV[0] # 0 is program location

def get_raider_io_path(path, params)
  uri = URI(RAIDER_IO_ROOT + path)
  uri.query = URI.encode_www_form params
  res = Net::HTTP.get_response(uri)

  res
end

def get_character_info(character_name, realm, region)
  req_params = {
    region: region,
    realm: realm,
    name: character_name,
    fields: DESIRED_RIO_FIELDS
  }
  get_raider_io_path('characters/profile', req_params)
end

params = { token: TOKEN, prefix: '!' }
bot = Discordrb::Commands::CommandBot.new(params)

bot.command :info do |event, args|
  char, server, = args.split '-'
  begin
    res = get_character_info(char, server, 'us').body
    res = JSON.parse res
  rescue Exception => e
    event.respond("Error Ocurred: #{e}")
    break
  end

  event << "Overview for: #{res['name']}-#{res['realm']}"\
      " | Guild: #{res['guild']['name']}"
  event << "M+ Score: #{res['mythic_plus_scores']['all']}"
  event << "Gear Equipped: #{res['gear']['item_level_equipped']} /"\
      " Gear Total: #{res['gear']['item_level_total']}"
  event << "Check the raider.io page: #{res['profile_url']}"
end

bot.run
