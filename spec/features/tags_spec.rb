require 'rails_helper'

describe('Tags Controller')  do
  before :each do
    @fetcher = FetcherTester.new
    @fixture_data = FixtureData.new
  end

  it 'should return pending for the index function' do
    VCR.use_cassette('all_tags_index_call') do
      visit tags_path
      expect(page.body).to eq(200.to_s)
    end
  end

  it 'should return values with counts' do
    VCR.use_cassette('tag_foo_call') do
      visit tag_path('foo')
      response = ''
      expect{ response = JSON.parse(page.body) }.not_to raise_error
      # binding.pry
      expect(response).to include('counts')
      expect(response["counts"]).to match a_hash_including(
        'collections' => 4,
        'adminpolicies' => 2,
        'items' => 13,
        'total_count' => 19
      )
    end
  end
end
