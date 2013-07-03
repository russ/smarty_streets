module SmartyStreets
  class Request
    class InvalidCredentials < Exception; end
    class MalformedData < Exception; end
    class PaymentRequired < Exception; end
    class NoValidCandidates < Exception; end
    class RemoteServerError < Exception; end

    attr_accessor :location

    def initialize(location)
      @location = location
    end

    def standardize!
      url = build_request_url(@location)
      handle_response(send_request(url))
    end

    private

    def handle_response(response)
      raise InvalidCredentials if response.code == 401
      raise MalformedData if response.code == 400
      raise PaymentRequired if response.code == 402
      raise RemoteServerError if response.code == 500
      raise NoValidCandidates if response.body.nil?

      JSON.parse(response.body).collect do |l|
        location = Location.new
        location.street = l['delivery_line_1']
        location.city = l['components']['city_name']
        location.state = l['components']['state_abbreviation']
        location.zip_code = l['components']['zipcode'] + '-' + l['components']['plus4_code']
        location.delivery_point_barcode = l['delivery_point_barcode']
        location.components = l['components']
        location.meta_data = l['metadata']
        location
      end
    end

    def send_request(url)
      HTTParty.get(url)
    end

    def build_request_url(location)
      parameters = {
        street: location.street,
        street2: location.street2,
        secondary: location.secondary,
        city: location.city,
        state: location.state,
        zip_code: location.zip_code,
        last_line: location.last_line,
        addressee: location.addressee,
        urbanization: location.urbanization,
        candidates: SmartyStreets.configuration.number_of_candidates,
        auth_id: SmartyStreets.configuration.auth_id,
        auth_token: SmartyStreets.configuration.auth_token
      }

      parameter_string = parameters.collect { |k,v|
        "#{k.to_s.gsub('_', '-')}=#{CGI.escape(v.to_s)}"
      }.join('&')

      'http://' + SmartyStreets.configuration.api_url +
      '/street-address/?' + parameter_string
    end
  end
end
