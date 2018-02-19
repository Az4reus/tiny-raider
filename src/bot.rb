require 'discordrb'
require 'net/http'
require 'json'
require_relative './raider_io'
require_relative './io'

if ARGV[0].nil?
  puts 'No Token specified!'
  exit 1
end
TOKEN = ARGV[0]

params = { token: TOKEN, prefix: '!' }
bot = Discordrb::Commands::CommandBot.new(params)

bot.include! RaiderIOModule

bot.run
