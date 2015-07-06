require 'rubygems'
require 'nokogiri'
#require 'open-uri'
require 'optparse'
require 'open-uri'
require 'sqlite3'

#handle options to the script

#define default options

options = OpenStruct.new
options.surah_number = []
options.number_aayaat = []
options.quran_uri = "http://quran.com/{surah_number}/{aayah_number}"
options.tafseer_uri = "http://quran.ksu.edu.sa/tafseer/saadi/sura{surah_number}-aya{aayah_number}"

OptionParser.new do |opts|
  opts.banner = "Usage: scrapecontent.rb [options]"

  opts.on('-s', '--surahnumber NUMBER', 'Surah number') { |v| options[:surah_number] = v }
  opts.on('-a', '--numberofaayaat NUMBER', 'Number of aayaat') { |v| options[:number_aayaat] = v }
  opts.on('-q', '--quranuri URI', 'Quran URI with {surah_number} and {aayah_number}') { |v| options[:quran_uri] = v }
  opts.on('-t', '--tafseeruri URI', 'Tafseer URI with {surah_number} and {aayah_number}') { |v| options[:tafseer_uri] = v }

end.parse!

#open the quran.com database from https://github.com/quran/quran.com-images
db = SQLite3::Database.new( "text.sqlite3.db" )

#run a query that produces a list of surah numbers (1-114), with the last aayah for each one
#then for each row within the results...
db.execute( "select sura, max(ayah) from sura_ayah_page_text group by sura" ) do |row|
  #set the surah number to s_no, and the last aayah to max_a_no
  s_no = row[0]
  max_a_no = row[1]
  #format s_no as a string with leading zeros if needed
  s_no_str = s_no.to_s.rjust(3, "0")
  #create a directory in the root of the project with the value of s_no_str as the name, and change to this directory
  Dir.mkdir "../#{s_no_str}"
  Dir.chdir "../#{s_no_str}"
  #copy the surah-sample file into memory, replace strings, and write
  
  #then from 1 to the last aayah...
  (1..max_a_no).each do |i|
    a_no = i
    puts "Current aayah number is #{s_no}:#{a_no}"
    #open a file in the ../_images directory with the format surahnumber_aayahnumber.png
    open("../_images/#{s_no}_#{a_no}.png", 'wb') do |file|
      #open the quran.com retina image and copy it to the aforementioned png file
      file << open("http://quran.com/images/ayat_retina/#{s_no}_#{a_no}.png").read
    end
  end
end

uri = "http://en.wikipedia.org/"
page = Nokogiri::HTML(open(uri))   

page.css('div#div_saadi').css('div')[1] #grab the second div inside of the dive entitled div_saadi

#for each element, output the text on one new line

puts page.class   # => Nokogiri::HTML::Document

