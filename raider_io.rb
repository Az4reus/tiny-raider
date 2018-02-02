require 'discordrb'

# Module specifically for dealing with raider.io and it's Swagger API
module RaiderIOModule
  extend Discordrb::Commands::CommandContainer

  @logger = Discordrb::Logger.new(false)

  # Queries raider IO to specified char. Currently specialised to US region.
  # Needs to be improved with better display, ideally an embed frame.
  command :io do |event, args|
    char, server, = args.split '-'

    if char.nil? || server.nil?
      @logger.warn "Caught bad user request: #{args}"
      return event.respond('Format is Char-Server, pretty please.')
    end

    resp = get_character_info(char, server, 'us')
    return print_bad_request(event, resp) if resp.code == '400'

    res = JSON.parse resp.body
    @logger.info "Good User Request for #{args}"

    event << "Overview for: #{res['name']}-#{res['realm']}"\
        " | Guild: #{res['guild']['name']}"
    event << "M+ Score: #{res['mythic_plus_scores']['all']}"
    event << "Gear Equipped: #{res['gear']['item_level_equipped']} /"\
        " Gear Total: #{res['gear']['item_level_total']}"
    event << "Check the raider.io page: #{res['profile_url']}"
  end

  def self.print_bad_request(event, http_response)
    body = JSON.parse http_response.body
    @logger.info "Caught raider.io bad Request: #{body}"
    event.respond("Bad request: #{body['message']}")
  end

  command :affixes do |event|
    resp = query_affixes
    body = JSON.parse resp.body

    if resp.code != '200'
      @logger.info "Raider.IO having some problems: #{body}"
      event.respond "Raider.io says no: #{body['message']}"
    end

    @logger.info "Responded to affix query to #{event.author.nick}"
    body['affix_details'].each do |affix|
      event << "**#{affix['name']}**: #{affix['description']}"
    end

    return event
  end
end
