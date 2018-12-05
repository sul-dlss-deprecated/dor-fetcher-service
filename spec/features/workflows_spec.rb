require 'rails_helper'

describe('Workflows Controller')  do
  before :each do
    @fixture_data = FixtureData.new
  end

  it 'the index of workflows found should be all workflows when not supplied a date range and all their druids should be present' do
    VCR.use_cassette('all_workflows_index_call') do
       visit workflows_path
       response = JSON.parse(page.body)
       # Ensure All Four Collection Druids Are Present
       result_should_contain_druids(@fixture_data.workflow_druids, response[workflows_key])
       # Ensure No Other Druids Are Present
       result_should_not_contain_druids(@fixture_data.accessioned_druids - @fixture_data.workflow_druids, response[workflows_key])
       expect(response[items_key]).to be_nil # Ensure No Items Were Returned
       expect(response[apos_key]).to be_nil  # Ensure No APOS Were Returned
       expect(response[collections_key]).to be_nil  # Ensure No Collections Were Returned
       verify_counts_section(response, workflows_key => @fixture_data.workflow_druids.size)
     end
  end

end
