require 'chefspec'
require 'chefspec/coveragereports'
if ENV['COVERAGE']
  ChefSpec::CoverageReports.add('json', '.coverage/results.json')
  at_exit { ChefSpec::Coverage.report! }
end
require 'chefspec/berkshelf'
