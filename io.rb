require 'net/http'
require 'json'

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
