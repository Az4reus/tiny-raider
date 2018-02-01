require 'discordrb'

# Module specifically for dealing with raider.io and it's Swagger API
module RaiderIOModule
  extend Discordrb::Commands::CommandContainer

  command :io do |event, args|
    puts "got query for #{args}"
    char, server, = args.split '-'

    res = get_character_info(char, server, 'us')
    return print_bad_request(event, res) if res.code == 400

    res = JSON.parse res.body
      
    event << "Overview for: #{res['name']}-#{res['realm']}"\
        " | Guild: #{res['guild']['name']}"
    event << "M+ Score: #{res['mythic_plus_scores']['all']}"
    event << "Gear Equipped: #{res['gear']['item_level_equipped']} /"\
        " Gear Total: #{res['gear']['item_level_total']}"
    event << "Check the raider.io page: #{res['profile_url']}"
  end

  def print_bad_request(event, http_response)
    event.respond("Bad request: #{http_response.body}")
  end
end
