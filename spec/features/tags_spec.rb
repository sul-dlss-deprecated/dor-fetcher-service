# frozen_string_literal: true

require 'rails_helper'

describe('Tags Controller') do
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

  it 'should return no results when the tag is not found' do
    VCR.use_cassette('tag_foo_call') do
      visit tag_path('foo')
      response = ''
      expect { response = JSON.parse(page.body) }.not_to raise_error
      expect(response).to include('counts')
      expect(response['counts']).to match a_hash_including(
        'total_count' => 0
      )
    end
  end

  it 'should return results when the tag is found' do
    VCR.use_cassette('tag_lem_call') do
      visit tag_path('lem')
      response = ''
      expect { response = JSON.parse(page.body) }.not_to raise_error
      expect(response).to include('counts')
      expect(response['counts']).to match a_hash_including(
        'collections' => 1,
        'items' => 1,
        'total_count' => 2
      )
      expect(response['items']).to match a_hash_including(
        'druid' => 'druid:bb001zc5754',
        'latest_change' => '2014-06-06T05:06:06Z',
        'title' => 'French Grand Prix and 12 Hour Rheims: 1954',
        'catkey' => '3051728'
      )
      expect(response['collections']).to match a_hash_including(
        'druid' => 'druid:nt028fd5773',
        'latest_change' => '2014-06-06T05:06:06Z',
        'title' => 'The Revs Institute for Automotive Research, Inc.',
        'catkey' => nil
      )
    end
  end
end
