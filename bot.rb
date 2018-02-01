require 'discordrb'
require 'net/http'
require 'json'
require_relative './raider_io'
require_relative './io'

RAIDER_IO_ROOT = 'https://raider.io/api/v1/'.freeze
DESIRED_RIO_FIELDS = 'mythic_plus_scores,'\
    'gear,'\
    'guild,'\
    'mythic_plus_recent_runs'.freeze

if ARGV[0].nil?
  p 'No Token specified!'
  exit 1
end
TOKEN = ARGV[0]

params = { token: TOKEN, prefix: '!' }
bot = Discordrb::Commands::CommandBot.new(params)

bot.include! RaiderIOModule

bot.run
