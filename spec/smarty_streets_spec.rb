require 'spec_helper'

describe SmartyStreets do
  let(:auth_id) { 'MYAUTHID' }
  let(:auth_token) { 'MYAUTHTOKEN' }
  let(:candidates) { 1 }
  let(:response) { double(:response, code: response_code, body: response_body) }
  let(:response_code) { }
  let(:response_body) { }


  before do
    SmartyStreets.configure do |c|
      c.auth_id    = auth_id
      c.auth_token = auth_token
      c.candidates = candidates
    end

    allow(HTTParty).to receive(:get).and_return(response)
  end

  context SmartyStreets::Request do
    context 'unauthorized request' do
      let(:response_code) { 401 }

      specify 'raises an InvalidCredentials error' do
        expect {
          locations = SmartyStreets.standardize {}
        }.to raise_error SmartyStreets::Request::InvalidCredentials
      end
    end

    context 'malformed data' do
      let(:response_code) { 400 }

      specify 'raises an InvalidCredentials error' do
        expect {
          SmartyStreets.standardize {}
        }.to raise_error SmartyStreets::Request::MalformedData
      end
    end

    context 'payment required' do
      let(:response_code) { 402 }

      specify 'raises an InvalidCredentials error' do
        expect {
          SmartyStreets.standardize {}
        }.to raise_error SmartyStreets::Request::PaymentRequired
      end
    end

    context 'remote server error' do
      let(:response_code) { 500 }

      specify 'raises an InvalidCredentials error' do
        expect {
          SmartyStreets.standardize {}
        }.to raise_error SmartyStreets::Request::RemoteServerError
      end
    end

    context 'successful request' do
      let(:response_code) { 200 }
      let(:response_body) { successful_response_data }
      let(:candidates) { 5 }
      let(:successful_response_data) { '[{"input_index":0,"candidate_index":0,"delivery_line_1":"1 Infinite Loop","lastline":"Cupertino CA 95014-2083","delivery_point_barcode":"950142083017","components":{"primary_number":"1","street_name":"Infinite","street_suffix":"Loop","city_name":"Cupertino","state_abbreviation":"CA","zipcode":"95014","plus4_code":"2083","delivery_point":"01","delivery_point_check_digit":"7"},"metadata":{"record_type":"S","county_fips":"06085","county_name":"Santa Clara","carrier_route":"C067","congressional_district":"18","rdi":"Commercial","elot_sequence":"0031","elot_sort":"A","latitude":37.33118,"longitude":-122.03062,"precision":"Zip9"},"analysis":{"dpv_match_code":"Y","dpv_footnotes":"AABB","dpv_cmra":"N","dpv_vacant":"N","active":"Y"}},{"input_index":0,"candidate_index":1,"addressee":"Apple Computer","delivery_line_1":"1 Infinite Loop","lastline":"Cupertino CA 95014-2084","delivery_point_barcode":"950142084016","components":{"primary_number":"1","street_name":"Infinite","street_suffix":"Loop","city_name":"Cupertino","state_abbreviation":"CA","zipcode":"95014","plus4_code":"2084","delivery_point":"01","delivery_point_check_digit":"6"},"metadata":{"record_type":"F","county_fips":"06085","county_name":"Santa Clara","carrier_route":"C067","congressional_district":"18","rdi":"Commercial","elot_sequence":"0032","elot_sort":"A","latitude":37.33118,"longitude":-122.03062,"precision":"Zip9"},"analysis":{"dpv_match_code":"Y","dpv_footnotes":"AABB","dpv_cmra":"N","dpv_vacant":"N","active":"Y"}}]' }

      specify 'makes a request for a standardized address' do
        locations = SmartyStreets.standardize do |location|
          location.street = '1 infinite loop'
          location.city = 'cupertino'
          location.state = 'calforna'
          location.zipcode = '95014'
        end

        expect(locations.first.street).to  eq '1 Infinite Loop'
        expect(locations.first.city).to    eq 'Cupertino'
        expect(locations.first.state).to   eq 'CA'
        expect(locations.first.zipcode).to eq '95014-2083'
      end
    end

    context 'address with no candidates' do
      let(:response_code) { 200 }
      let(:candidates) { 5 }

      specify 'makes a request for a standardized address' do
        expect {
          locations = SmartyStreets.standardize {}
        }.to raise_error SmartyStreets::Request::NoValidCandidates
      end
    end
  end

end