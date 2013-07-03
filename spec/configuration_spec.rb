require 'spec_helper'

describe SmartyStreets::Configuration do
  before do
    SmartyStreets.configure do |c|
      c.api_url = 'apiurl'
      c.auth_id = 'MYAUTHID'
      c.auth_token = 'MYAUTHTOKEN'
      c.number_of_candidates = 1
    end
  end

  it 'sets the api_url' do
    expect(SmartyStreets.configuration.api_url).to eq 'apiurl'
  end

  it 'sets the auth_id' do
    expect(SmartyStreets.configuration.auth_id).to eq 'MYAUTHID'
  end

  it 'sets the auth_token' do
    expect(SmartyStreets.configuration.auth_token).to eq 'MYAUTHTOKEN'
  end

  it 'sets the number_of_candidates' do
    expect(SmartyStreets.configuration.number_of_candidates).to eq 1
  end
end
