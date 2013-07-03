require 'spec_helper'

describe SmartyStreets do
  before do
  end

  context SmartyStreets::Request do
    context 'unauthorized request' do
      let(:unauthorized_request) do
        double(:response, code: 401)
      end

      before do
        SmartyStreets.configure do |c|
          c.auth_id = 'ERROR'
          c.auth_token = 'ERROR'
        end
        HTTParty.stub(:get).and_return(unauthorized_request)
      end

      specify 'raises an InvalidCredentials error' do
        expect {
          locations = SmartyStreets.standardize do |location|
            location.street = '1 infinite loop'
            location.city = 'cupertino'
            location.state = 'california'
            location.zip_code = '95014'
          end
        }.to raise_error SmartyStreets::Request::InvalidCredentials
      end
    end

    context 'malformed data' do
      let(:malformed_data_request) do
        double(:response, code: 400)
      end

      before do
        SmartyStreets.configure do |c|
          c.auth_id = 'ERROR'
          c.auth_token = 'ERROR'
        end
        HTTParty.stub(:get).and_return(malformed_data_request)
      end

      specify 'raises an InvalidCredentials error' do
        expect {
          locations = SmartyStreets.standardize do |location|
            location.street = '1 infinite loop'
            location.city = 'cupertino'
            location.state = 'california'
            location.zip_code = '95014'
          end
        }.to raise_error SmartyStreets::Request::MalformedData
      end
    end

    context 'payment required' do
      let(:payment_required_request) do
        double(:response, code: 402)
      end

      before do
        SmartyStreets.configure do |c|
          c.auth_id = 'ERROR'
          c.auth_token = 'ERROR'
        end
        HTTParty.stub(:get).and_return(payment_required_request)
      end

      specify 'raises an InvalidCredentials error' do
        expect {
          locations = SmartyStreets.standardize do |location|
            location.street = '1 infinite loop'
            location.city = 'cupertino'
            location.state = 'california'
            location.zip_code = '95014'
          end
        }.to raise_error SmartyStreets::Request::PaymentRequired
      end
    end

    context 'remote server error' do
      let(:remote_server_error_request) do
        double(:response, code: 500)
      end

      before do
        SmartyStreets.configure do |c|
          c.auth_id = 'ERROR'
          c.auth_token = 'ERROR'
        end
        HTTParty.stub(:get).and_return(remote_server_error_request)
      end

      specify 'raises an InvalidCredentials error' do
        expect {
          locations = SmartyStreets.standardize do |location|
            location.street = '1 infinite loop'
            location.city = 'cupertino'
            location.state = 'california'
            location.zip_code = '95014'
          end
        }.to raise_error SmartyStreets::Request::RemoteServerError
      end
    end

    context 'successful request' do
      let(:successful_response) do
        double(:response, code: 200, body: successful_response_data)
      end

      before do
        SmartyStreets.configure do |c|
          c.auth_id = 'MYAUTHID'
          c.auth_token = 'MYAUTHTOKEN'
          c.number_of_candidates = 5
        end
        HTTParty.stub(:get).and_return(successful_response)
      end

      specify 'makes a request for a standardized address' do
        locations = SmartyStreets.standardize do |location|
          location.street = '1 infinite loop'
          location.city = 'cupertino'
          location.state = 'calforna'
          location.zip_code = '95014'
        end

        expect(locations.first.street).to eq '1 Infinite Loop'
        expect(locations.first.city).to eq 'Cupertino'
        expect(locations.first.state).to eq 'CA'
        expect(locations.first.zip_code).to eq '95014-2083'
      end
    end

    context 'address with no candidates' do
      let(:unsuccessful_response) do
        double(:response, code: 200, body: unsuccessful_response_data)
      end

      before do
        SmartyStreets.configure do |c|
          c.auth_id = 'MYAUTHID'
          c.auth_token = 'MYAUTHTOKEN'
          c.number_of_candidates = 5
        end
        HTTParty.stub(:get).and_return(unsuccessful_response)
      end

      specify 'makes a request for a standardized address' do
        expect {
          locations = SmartyStreets.standardize do |location|
            location.street = '1234 Unicorn Lane'
            location.city = 'earth'
            location.state = 'galaxy'
            location.zip_code = '1234923'
          end
        }.to raise_error SmartyStreets::Request::NoValidCandidates
      end
    end
  end

  def successful_response_data
    '[{"input_index":0,"candidate_index":0,"delivery_line_1":"1 Infinite Loop","last_line":"Cupertino CA 95014-2083","delivery_point_barcode":"950142083017","components":{"primary_number":"1","street_name":"Infinite","street_suffix":"Loop","city_name":"Cupertino","state_abbreviation":"CA","zipcode":"95014","plus4_code":"2083","delivery_point":"01","delivery_point_check_digit":"7"},"metadata":{"record_type":"S","county_fips":"06085","county_name":"Santa Clara","carrier_route":"C067","congressional_district":"18","rdi":"Commercial","elot_sequence":"0031","elot_sort":"A","latitude":37.33118,"longitude":-122.03062,"precision":"Zip9"},"analysis":{"dpv_match_code":"Y","dpv_footnotes":"AABB","dpv_cmra":"N","dpv_vacant":"N","active":"Y"}},{"input_index":0,"candidate_index":1,"addressee":"Apple Computer","delivery_line_1":"1 Infinite Loop","last_line":"Cupertino CA 95014-2084","delivery_point_barcode":"950142084016","components":{"primary_number":"1","street_name":"Infinite","street_suffix":"Loop","city_name":"Cupertino","state_abbreviation":"CA","zipcode":"95014","plus4_code":"2084","delivery_point":"01","delivery_point_check_digit":"6"},"metadata":{"record_type":"F","county_fips":"06085","county_name":"Santa Clara","carrier_route":"C067","congressional_district":"18","rdi":"Commercial","elot_sequence":"0032","elot_sort":"A","latitude":37.33118,"longitude":-122.03062,"precision":"Zip9"},"analysis":{"dpv_match_code":"Y","dpv_footnotes":"AABB","dpv_cmra":"N","dpv_vacant":"N","active":"Y"}}]'
  end

  def unsuccessful_response_data
    nil
  end
end
