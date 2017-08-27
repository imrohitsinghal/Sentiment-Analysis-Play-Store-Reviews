require_relative '../reviews/latest_reviews'
require_relative '../reviews/process-reviews'
require_relative '../report/html_generator'


$PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../'))

namespace :reviews do
  desc "Fetch all latest reviews"
  task :fetch do
    cleanup
    FetchResponse.new(ENV['PACKAGE_NAME']).fetch_reviews
  end

  desc "Process all reviews"
  task :analyze do
    AnalyzeReviews.new.process
  end

  desc "Generate HTML Report"
  task :output do
    ProduceHtml.new.generate_html
  end
end

def cleanup
  puts "Cleaned up previous CSV files"
  `rm -rf #{$PROJECT_ROOT}/report/review_report.html`
  `rm -rf #{$PROJECT_ROOT}/csv/*.csv`
end


