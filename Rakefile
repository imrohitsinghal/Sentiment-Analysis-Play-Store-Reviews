$: << File.dirname(__FILE__)

Dir.glob('rake-tasks/*.rake').each { |r| import r }

PACKAGE_NAME = ENV['PACKAGE_NAME'] ? ENV['PACKAGE_NAME'] : 'false'
ENV['PACKAGE_NAME'] = PACKAGE_NAME

REVIEW_DATE = ENV['REVIEW_DATE'] ? ENV['REVIEW_DATE'] : Time.new.day
ENV['REVIEW_DATE'] = REVIEW_DATE.to_s


