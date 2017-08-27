$: << File.dirname(__FILE__)

Dir.glob('rake-tasks/*.rake').each { |r| import r }

PACKAGE_NAME = ENV['PACKAGE_NAME'] ? ENV['PACKAGE_NAME'] : 'false'
ENV['PACKAGE_NAME'] = PACKAGE_NAME