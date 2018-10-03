require 'smarter_csv'
require 'builder'

class ProduceHtml
  def initialize
    @reviews = SmarterCSV.process('csv/functionality_reviews.csv')
  end

  def build_html_table(data)
    html = Builder::XmlMarkup.new(indent: 2)
    html.table{
      html.tr { data[0].keys.each { |key| html.td(key) } }
      data.each { |row| html.tr { row.values.each { |value| html.td(value) } } }
    }
  end

  def generate_html
    isEmpty? ? exit : puts { 'Generating HTML' }
    table_data = build_html_table @reviews.sort_by! { |hsh| hsh[:area] }
    html_file  = File.read(__dir__ + '/output.tmpl')
    html_file  = html_file.gsub('#TABLE#', table_data)
    html_file  = html_file.gsub(' <td:area/>', '<td><strong>Area</strong></td>')
    html_file  = html_file.gsub('<td:feedback/>', '<td><strong>Review</strong></td>')
    File.open(__dir__ + '/review_report.html', 'w') { |f| f.write(html_file) }
  end

  def isEmpty?
    exit_status = false
    if File.zero?('csv/newest_reviews.csv') || File.zero?('csv/functionality_reviews.csv')
      puts 'No Reviews Present. Please check input date'
      exit_status = true
    end
    # puts 'Exit Status' + exit_status.to_s
    exit_status
  end
end
