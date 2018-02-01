require 'discordrb'

# Module specifically for dealing with raider.io and it's Swagger API
module RaiderIOModule
  extend Discordrb::Commands::CommandContainer

  command :io do |event, args|
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
end
