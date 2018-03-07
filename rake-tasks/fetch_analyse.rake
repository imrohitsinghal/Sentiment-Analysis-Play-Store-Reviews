require_relative '../reviews/latest_reviews'
require_relative '../reviews/sentimental_process'
require_relative '../reviews/analyse_reviews'
require_relative '../report/html_generator'


$PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../'))

namespace :reviews do
  namespace :run do
    desc "Run all"
    task :all => [:fetch, :analyze]

    desc "Fetch all latest reviews"
    task :fetch do
      cleanup
      FetchResponse.new(ENV['PACKAGE_NAME']).fetch_reviews(ENV['REVIEW_DATE'])
    end

    desc "Analyze all reviews using AYLIEN API"
    task :analyze do
      configure_cred
      AnalyzeReviews.new.analyze_each_review
      AnalyzeReviews.new.close_files
    end

    desc "Process all reviews without using API"
    task :process do
      SentimentalProcess.new.process
    end

    desc "Generate HTML Report"
    task :output do
      ProduceHtml.new.generate_html
    end
  end
end

def configure_cred
  AylienTextApi.configure do |config|
    config.app_id        =    'ba0e43b0'
    config.app_key       =    'c5bf0f6d4080f1fbc03a7a11ae67c696'
  end
end


def cleanup
  puts "Cleaned up previous CSV files"
  `rm -rf #{$PROJECT_ROOT}/report/review_report.html`
  `rm -rf #{$PROJECT_ROOT}/csv/*.csv`
end


