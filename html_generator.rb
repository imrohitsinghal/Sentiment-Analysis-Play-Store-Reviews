require 'smarter_csv'
require 'builder'

array_of_hashes = SmarterCSV.process('functionality_reviews.csv')

def build_html_table data
html = Builder::XmlMarkup.new(:indent => 2)
html.table {
  html.tr { data[0].keys.each { |key| html.th(key)}}
  data.each { |row| html.tr { row.values.each { |value| html.td(value)}}}
}
end

table_data = build_html_table array_of_hashes.sort_by! { |hsh| hsh[:area] }
print table_data