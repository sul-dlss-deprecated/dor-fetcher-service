class WorkflowsController < ApplicationController
  # API call to get a full list of all workflows
  #
  # @param [querystring] Parameters can be specified in the querystring
  #   * rows = number of results to return (set to 0 to only get count)
  #   * first_modified = datetime in UTC (default: earliest possible date)
  #   * last_modified = datetime in UTC (default: current time)
  #
  # Example:
  #   http://localhost:3000/workflows.json   # gives all workflows in json format
  #   http://localhost:3000/workflows?rows=0 # returns only the count of workflows in json format
  #   http://localhost:3000/workflows.xml?first_modified=2014-01-01T00:00:00Z&last_modified=2014-02-01T00:00:00Z# returns only the workflows published in January of 2014 in XML format
  #   http://localhost:3000/workflows?first_modified=2014-01-01T00:00:00Z # returns only the workflows published SINCE January of 2014 up until today in json format
  #   http://localhost:3000/workflows?first_modified=2014-01-01T00:00:00Z&rows=0 # returns only the count of workflows published SINCE January of 2014 up until today in json format
  def index
    result = find_all_fedora_type(params, :workflow)
    render_result(result)
  end

end
