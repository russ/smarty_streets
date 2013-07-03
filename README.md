# SmartyStreets

A ruby library to integrate with the SmartyStreets API.

## Installation

Add this line to your application's Gemfile:

    gem 'smarty_streets'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smarty_streets

## Usage

You must have valid tokens from http://www.smartystreets.com

```ruby
SmartyStreets.configure do |c|
  c.auth_id = 'MY-AUTH-ID'
  c.auth_token = 'MY-AUTH-TOKEN'
  c.number_of_candidates = 5
end

locations = SmartyStreets.standardize do |location|
  location.street = '1 infinite loop'
  location.city = 'cupertino'
  location.state = 'california'
  location.zip_code = '95014'
end

# #<SmartyStreets::Location:0x007fb4bbb507d0 @street="1 Infinite Loop", @city="Cupertino", @state="CA", @zip_code="95014-2083", @delivery_point_barcode="950142083017", @components={"primary_number"=>"1", "street_name"=>"Infinite", "street_suffix"=>"Loop", "city_name"=>"Cupertino", "state_abbreviation"=>"CA", "zipcode"=>"95014", "plus4_code"=>"2083", "delivery_point"=>"01", "delivery_point_check_digit"=>"7"}, @meta_data={"record_type"=>"S", "county_fips"=>"06085", "county_name"=>"Santa Clara", "carrier_route"=>"C067", "congressional_district"=>"18", "rdi"=>"Commercial", "elot_sequence"=>"0031", "elot_sort"=>"A", "latitude"=>37.33118, "longitude"=>-122.03062, "precision"=>"Zip9"}>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
