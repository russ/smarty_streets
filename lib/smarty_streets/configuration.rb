module SmartyStreets
  class Configuration
    # API url for SmartyStreets
    attr_accessor :api_url

    # AUTH ID from SmartyStreets
    attr_accessor :auth_id

    # AUTH TOKEN from SmartyStreets
    attr_accessor :auth_token

    # Number of candidates to provide when making a request.
    attr_accessor :number_of_candidates

    def initialize
      @api_url = 'api.smartystreets.com'
      @number_of_candidates = 1
    end

    # Returns a hash of all configurable options
    def to_hash
      OPTIONS.inject({}) do |hash, option|
        hash.merge(option.to_sym => send(option))
      end
    end
  end
end
