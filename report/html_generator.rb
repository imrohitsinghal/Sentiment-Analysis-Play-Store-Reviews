require 'smarter_csv'
require 'builder'

class ProduceHtml

  def initialize
    @array_of_hashes = SmarterCSV.process('csv/functionality_reviews.csv')
  end

  def build_html_table data
    html = Builder::XmlMarkup.new(:indent => 2)
    html.table {
      html.tr { data[0].keys.each { |key| html.th(key) } }
      data.each { |row| html.tr { row.values.each { |value| html.td(value) } } }
    }
  end

  def generate_html
    table_data = build_html_table @array_of_hashes.sort_by! { |hsh| hsh[:area] }
    html_file = File.read(__dir__+"/result.html")
    html_file= html_file.gsub("#TABLE#", table_data)
    File.open(__dir__ + "/review_report.html", 'w') { |f| f.write(html_file) }
  end

end
