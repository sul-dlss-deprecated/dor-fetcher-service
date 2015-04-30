require 'rails_helper'

describe("Indexer lib")  do
  include ApplicationHelper
  
  before :each do
    @indexer = IndexerTester.new
    @testing_doc_cache = Rails.root.to_s + (File::SEPARATOR+'spec'+File::SEPARATOR+'purl'+File::SEPARATOR+'document_cache')
    @sample_doc_path =  @testing_doc_cache + (File::SEPARATOR+'bb'+File::SEPARATOR+'050'+File::SEPARATOR+'dj'+File::SEPARATOR+'7711')
    @sample_doc_path_files_missing = (File::SEPARATOR+'bb'+File::SEPARATOR+'050'+File::SEPARATOR+'dj'+File::SEPARATOR+'0000')
  end
  
  it "returns the path the deletes directory as a pathname" do
    expect(@indexer.path_to_deletes_dir.class).to eq(Pathname)
  end
  
  it "places the specified .deletes dir should be in the root of the purl directory" do
    expect(@indexer.path_to_deletes_dir.to_s.downcase).to eq("/purl/document_cache/.deletes")
  end
  
  xit "gets all changed directory in a branch and returns one reference to each object directory" do
    #TODO:  Figure out how to work touch times and make this test not take forever
  end
  
  it "gets the title from the mods file" do
    expect(@indexer.read_mods_for_object(@sample_doc_path)).to match({:title_tsi=>"This is Pete's New Test title for this object."})
  end
  
  it "raises an error when there is no mods" do
    expect{@indexer.read_mods_for_object(@sample_doc_path_files_missing)}.to raise_error(Errno::ENOENT)
  end
  
  it "gets the druid from identityMetadata" do
    expect(@indexer.get_druid_from_identityMetadata(@sample_doc_path)).to match("druid:bb050dj7711")
  end
  
  it "raises an error when there is no identityMetadata" do
    expect{@indexer.get_druid_from_identityMetadata(@sample_doc_path_files_missing)}.to raise_error(Errno::ENOENT)
  end
  
  it "gets true and false data from the public xml regarding release status" do
    expect(@indexer.get_release_status(@sample_doc_path)).to match({:false => ["Atago"],:true => ["CARRICKR-TEST", "Robot_Testing_Feb_5_2015"]})
  end
  
  it "raises an error when there is no public xml" do
    expect{@indexer.get_release_status(@sample_doc_path_files_missing)}.to raise_error(Errno::ENOENT)
  end
  
  it "returns the doc hash when all needed files are present" do
    expect(@indexer.solrize_object(@sample_doc_path)).to match({:identityMetadata_objectType_t => ["item"], :false_releases_ssim => ["Atago"],:id => "druid:bb050dj7711", :title_tsi => "This is Pete's New Test title for this object.",:true_releases_ssim => ["CARRICKR-TEST", "Robot_Testing_Feb_5_2015"], :is_member_of_collection_s => ["druid:nt028fd5773", "druid:wn860zc7322"],})
  end
  
  it "returns the empty doc hash when it cannot open a file" do
   expect(@indexer.solrize_object(@sample_doc_path_files_missing)).to match({})
  end
  
  xit "logs an error when a file cannot be found for a purl object" do
  end
  
  it "returns an RSolr Client when connecting to solr" do
    expect(@indexer.establish_solr_connection.class).to eq(RSolr::Client)
  end
  
  it "determines when the addition and commit of solr documents was successful" do
    VCR.use_cassette('submit_one_doc') do
      docs = [@indexer.solrize_object(@sample_doc_path)]
      expect(@indexer.add_and_commit_to_solr(docs)).to be_truthy
    end
  end
  
  it "determines when the solr commit was successful" do
    VCR.use_cassette('successful_solr_commit') do
      expect(@indexer.commit_to_solr(@indexer.establish_solr_connection)).to be_truthy
    end
  end
  
  it "determines from the RSolr response if the solr operation was successful" do
    resp = {"responseHeader"=>{"status"=>0, "QTime"=>77}} 
    expect(@indexer.parse_solr_response(resp)).to be_truthy
  end
  
  it "determines from the RSolr response if the solr operation failed" do
    resp = {"responseHeader"=>{"status"=>-1, "QTime"=>77}} 
    expect(@indexer.parse_solr_response(resp)).to be_falsey
  end
  
  it "determines from the RSolr response if the solr cloud is overloaded and sleeps the thread" do
    resp = {"responseHeader"=>{"status"=>0, "QTime"=>DorFetcherService::Application.config.solr_indexing['sleep_when_response_time_exceeds'].to_i}}
    begin_time = Time.now
    expect(@indexer.parse_solr_response(resp)).to be_truthy
    end_time = Time.now
    expect(end_time-begin_time).to be >= DorFetcherService::Application.config.solr_indexing['sleep_seconds_if_overloaded'].to_i
  end
  
  it "determines if the addition of solr documents was successful" do
    VCR.use_cassette('doc_submit_fails') do
      docs = [@indexer.solrize_object(@sample_doc_path)]
      expect(@indexer.add_and_commit_to_solr(docs)).to be_falsey
    end
  end
  
  it "determines if the solr commit was successful" do
    #FYI this will fail if you have your local solr running, because obviously you can connect to it 
    #It will also record a cassette and keep failing due to that cassette, but you need to keep this wrapped else VCR yells at you for connecting out
    #So if it fails, shut down local solr and delete the cassette, all tests should then pass since the other tests have cassettes 
    VCR.use_cassette('failed_solr_commit') do
      expect(@indexer.commit_to_solr(@indexer.establish_solr_connection)).to be_falsey
    end
  end
  
  it "returns the path to the delete directory as Pathname" do
    expect(@indexer.path_to_deletes_dir.class).to eq(Pathname)
  end
  
  it "adds the timestamp to documents" do 
    documents = @indexer.add_timestamp_to_documents([{},{}])
    expect(documents[0][:indexed_dtsi].class).to eq(String)
    expect(documents[1][:indexed_dtsi].class).to eq(String)
  end
  
  it "should return a string for the purl mount location" do
    expect(@indexer.purl_mount_location.class).to eq(String)
  end
  
  describe("deleting solr documents") do
    before :each do
      #Paths for copying
      @base_path = @sample_doc_path[0...-4]
      @source_dir = @base_path+"6667.src"
      @dest_dir = @source_dir[0...-4] #trim off the .src
      
      @druid = 'bb050dj6667'
      
      @druid_object = DruidTools::PurlDruid.new(@druid, @testing_doc_cache)
      FileUtils.cp_r  @source_dir, @dest_dir
      allow(@indexer).to receive(:purl_mount_location).and_return(@testing_doc_cache)
    end
    
    after :each do
      FileUtils.rm_r @dest_dir if File.directory?(@dest_dir) #remove the 6667 files
      remove_delete_records(@testing_doc_cache+File::SEPARATOR+'.deletes', ['bb050dj6667'])
    end
     
    it "detects that the druid is not deleted when its files are still present in the document cache" do
      expect(@indexer.is_deleted?(@druid)).to be_falsey
    end
    
    it "detects that the druid is deleted when its files are not present in the document cache" do
      FileUtils.rm_r @dest_dir #remove our testing druid
      expect(@indexer.is_deleted?(@druid)).to be_truthy
    end
    
    it "does not delete the test druid when the files still remain in the document cache" do
      #Delete the druid to create the .deletes dir record
      FileUtils.rm_r @dest_dir
      @druid_object.creates_delete_record
      #Copy the files back in
      FileUtils.cp_r  @source_dir, @dest_dir
      
      expect(@indexer.remove_deleted_objects_from_solr(mins_ago: 5)).to match({:success=>true, :docs=>[]})
      
    end
    
    it "deletes the druid from solr the files do not remain in the document cache" do
      #Index the druid into solr
      VCR.use_cassette('successful_solr_delete') do
        start_time = Time.now
        sleep(1) #make sure at least one second passes for the timestamp checks
        @indexer.add_and_commit_to_solr(@indexer.solrize_object(@dest_dir)) #commit 6667 to solr
        FileUtils.rm_r @dest_dir #remove its files
        @druid_object.creates_delete_record #create its delete record
        
        result = @indexer.remove_deleted_objects_from_solr(mins_ago: 5)
        sleep(1) #make sure at least one second passes for the timestamp checks
        end_time = Time.now
        #Check the result
        expect(result[:success]).to be_truthy
        expect(result[:docs].size).to eq(1)
        expect(result[:docs][0][:id]).to match("druid:bb050dj6667")
        expect(result[:docs][0][:deleted_tsi]).to match("true")  
        expect(result[:docs][0][:indexed_dtsi].class).to eq(String) #make sure it isn't a nill 
        
        #Make sure the index time stamp was set properly, it should be between the start time and end time
        index_time = Time.parse(result[:docs][0][:indexed_dtsi])
        expect(end_time > index_time).to be_truthy
        expect(start_time < index_time).to be_truthy
      end
      
      
    end
    
    it "detects multiple deletes in one pass" do
      fake_druids = ['bb050dj1817', 'bb050dj1885', 'bb050dj1971', 'bb050dj1927']
      
      fake_druids.each do |f_d|
        d_o = DruidTools::PurlDruid.new(f_d, @testing_doc_cache)
        d_o.creates_delete_record #Create the delete record, no files in the document_cache to delete except for 6667
      end
      FileUtils.rm_r @dest_dir #remove 6667 files
      
      VCR.use_cassette('multiple_druid_delete') do
        result = @indexer.remove_deleted_objects_from_solr(mins_ago: 5)
        expect(result[:success]).to be_truthy
        expect(result[:docs].size == fake_druids.size).to be_truthy
      end
      
      #Remove these delete records
      remove_delete_records(@testing_doc_cache+File::SEPARATOR+'.deletes', fake_druids)
      
    end
  end
  
  it "gets the object type" do
    expect(@indexer.get_objectType_from_identityMetadata(@sample_doc_path)).to match(['item'])
  end
  
  it "gets multiple object types when an object has multiple types" do
     @druid_object = DruidTools::PurlDruid.new('druid:ct961sj2730', @testing_doc_cache)
     expect(@indexer.get_objectType_from_identityMetadata( @druid_object.path)).to match(['collection','set'])
  end
  
  it "gets the collections and sets the object is a member of" do
    expect(@indexer.get_membership_from_publicxml(@sample_doc_path)).to match(['druid:nt028fd5773','druid:wn860zc7322'])
  end
  
  
  xit "queries solr for documents modified between two timestaps" do
  end
  
  xit "returns an empty array when its query to solr for documents between two timestamps fails" do
  end
  
  xit "formats the solr response of documents properly" do
  end
  
end