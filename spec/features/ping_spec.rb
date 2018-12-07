# frozen_string_literal: true

require 'rails_helper'

describe 'Ping', type: :request, integration: true do
  it 'returns an OK status when calling the root url' do
    visit root_path
    expect(page.status_code).to eq(200)
    expect(page).to have_content('PASSED')
  end

  describe 'okcomputer' do
    before do
      # Test suite should not require Solr running to test okcomputer
      allow_any_instance_of(SolrCheck).to receive(:perform_request).and_return(true)
      # Stub the checks that depend on files on disk
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:new).with(Rails.root.join('REVISION')).and_return(revision_file)
      allow(File).to receive(:new).with(Rails.root.join('tmp', 'restart.txt')).and_return(restart_txt_file)

      visit okcomputer.okcomputer_checks_path
    end

    let(:version) { File.read(Rails.root.join('VERSION')).strip }
    let(:restart_time) { '2018-12-07 09:23:35 -0800' }
    let(:restart_txt_file) { double(mtime: restart_time) }
    let(:deploy_time) { '2017-11-07 09:23:35 -0800' }
    let(:revision_file) { double(mtime: deploy_time) }

    it 'returns an HTTP 200 status' do
      expect(page.status_code).to eq(200)
    end

    it 'includes the application name ' do
      expect(page).to have_content("Application name: #{Rails.application.config.app_name}")
    end

    it 'includes the version' do
      expect(page).to have_content("Version: #{version}")
    end

    it 'includes the Rails env' do
      expect(page).to have_content('Rails environment: test')
    end

    it 'includes the last restart time' do
      expect(page).to have_content("Last restart time: #{restart_time}")
    end

    it 'includes the last deploy time' do
      expect(page).to have_content("Last deployed time: #{deploy_time}")
    end

    it 'includes Solr information' do
      expect(page).to have_content("Solr URL: #{Rails.application.config.solr_url}")
    end
  end
end
