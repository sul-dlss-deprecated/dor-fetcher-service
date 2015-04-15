class ChangesController < ApplicationController
  include Indexer
  
  
  # API call to get a full list of all solr documents modified between two times
  #
  # @return [JSON] Will return json 
  #
  # @param [querystring] Parameters can be specified in the querystring
  #   #   * first_modified = datetime in UTC (default: earliest possible date)
  #   * last_modified = datetime in UTC (default: current time)
  #
  # Example:
  #   http://localhost:3000/changes  # gives all items modified from the Unix Epoch until now
  #   http://localhost:3000/changes?first_modified=2014-01-01T00:00:00Z # returns only the modified documents SINCE January of 2014 up until today in json format
  def index
    result = get_modified_from_solr(first_modified: params['first_modified'], last_modified: params['last_modified'])
    render_result(result)
  end
  
   #API call to get a full list of all solr documents modified between two times
   #
   # @return [JSON] Will return json 
   #
   # @param [querystring] Parameters can be specified in the querystring
   #   #   * first_modified = datetime in UTC (default: earliest possible date)
   #   * last_modified = datetime in UTC (default: current time)
   #
   # Example:
   #   http://localhost:3000/changes  # gives all items modified from the Unix Epoch until now
   #   http://localhost:3000/changes?first_modified=2014-01-01T00:00:00Z # returns only the modified documents SINCE January of 2014 up until today in json format
  def show
    presult = get_modified_from_solr(first_modified:  params['first_modified'], last_modified: params['last_modified'])
    render_result(result)
  end
end