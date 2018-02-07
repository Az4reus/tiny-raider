require 'discordrb'

# Module specifically for dealing with raider.io and it's Swagger API
module RaiderIOModule
  extend Discordrb::Commands::CommandContainer

  @logger = Discordrb::Logger.new(false)

  # Queries raider IO to specified char. Currently specialised to US region.
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
    character_information_embed(res, event)
  end

  def self.print_bad_request(event, http_response)
    body = JSON.parse http_response.body
    @logger.info "Caught raider.io bad Request: #{body}"
    event.respond("Bad request: #{body['message']}")
  end

  def self.character_information_embed(r, event)
    nick = event.author.display_name
    footer = Discordrb::Webhooks::EmbedFooter.new(text: "Requested by #{nick}")
    thumb = Discordrb::Webhooks::EmbedThumbnail.new(url: r['thumbnail_url'])

    begin
      event.channel.send_embed do |e|
        e.title = "#{r['name']}-#{r['realm']}"
        e.color = 3_447_001
        e.thumbnail = thumb
        e.footer = footer
        e.add_field(name: 'M+ Score',
                    value: "**__#{r['mythic_plus_scores']['all']}__**",
                    inline: true)
        e.add_field(name: 'Gear',
                    value: "#{r['gear']['item_level_equipped']}/"\
                           "#{r['gear']['item_level_total']}",
                    inline: true)
        e.add_field(name: 'Guild', value: r['guild']['name'], inline: true)
        e.description = "[Read more at raider.io](#{r['profile_url']})"
      end
    rescue Discordrb::Errors::NoPermission => _
      @logger.warn 'No permission to send embed, sending fallback'
      send_char_info_fallback(r, event)
    end
  end

  def send_char_info_fallback(r, event)
    event << "Overview for: #{r['name']}-#{r['realm']}" \
             " | Guild: #{r['guild']['name']}"
    event << "M+ Score: #{r['mythic_plus_scores']['all']}"
    event << "Gear Equipped: #{r['gear']['item_level_equipped']} /" \
             " Gear Total: #{r['gear']['item_level_total']}"
    event << "Check the raider.io page: #{r['profile_url']}"
  end
end
