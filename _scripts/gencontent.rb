require 'nokogiri'
require 'optparse'
require 'open-uri'
require 'sqlite3'

#handle options to the script

#define default options
options = {}

#pull options from command line
OptionParser.new do |opts|
  #define a usage banner to be shown when no options are presented, or wrong option
  opts.banner = "Usage: " + File.basename($0) + " [options]"

  #takes a mandatory argument of the surah number
  opts.on('-s', '--surahnumber NUMBER', Integer, 'Surah number (required)') do |s_number|
          options[:surah_number] = s_number
        end
end.parse!

#Now raise an exception if we have not found a host option
raise OptionParser::MissingArgument if options[:surah_number].nil?

#open the quran.com database from https://github.com/quran/quran.com-images
db = SQLite3::Database.new( "text.sqlite3.db" )
#open our own database, created from tanzil.net
qdb = SQLite3::Database.new( "quran.sqlite3.db" )

#define some variables for use later
s_no = nil
max_a_no = nil
s_no_str = nil

#run a query that produces the last aayah for the specified surah
db.execute( "select sura, max(ayah) from sura_ayah_page_text where sura = '#{options[:surah_number]}'" ) do |row|
  unless row.nil?
    #we have a result
    puts "Processing files for surah #{options[:surah_number]}"
    s_no = row[0]
    max_a_no = row[1]
    #format s_no as a string with leading zeros if needed
    s_no_str = s_no.to_s.rjust(3, "0")
    #and without leading zeros
    s_no_str_plain = s_no.to_s
    #let's see if there is a directory for the surah
    if Dir.exists?("../#{s_no_str}")
       #create a directory in the root of the project with the value of s_no_str as the name
      puts "Directory already exists, moving on..."
    else
      Dir.mkdir "../#{s_no_str}"
    end  
  else 
    #the row was empty, no result
    puts "This surah (#{options[:surah_number]}) does not exist in the table."
  end
  #copy the surah-sample file into memory
  surah_sample = File.read("../_sample-files/surah-sample.tex")
  #replace strings
  surah_sample = surah_sample.gsub('SNO', s_no_str_plain)
  surah_sample = surah_sample.gsub('SZO', s_no_str)
  #write the file with the s_no_str title
  File.write("../_surah_titles/#{s_no_str}.tex", surah_sample)
  puts "Surah file #{s_no_str}.tex outputted successfully."
  #then from 1 to the last aayah...
  (1..max_a_no).each do |i|
    a_no = i
    a_no_str_plain = i.to_s
    puts "Processing aayah #{a_no}..."
    #grab the KSU tafseer using Nokogiri
    uri = "http://quran.ksu.edu.sa/tafseer/saadi/sura#{s_no_str_plain}-aya#{a_no_str_plain}.html"
    page = Nokogiri::HTML(open(uri))
    #grab the second div inside of the div entitled div_saadi
    result = page.css('div#div_saadi div')[1]
    #go through the child nodes in the result, one by one, filtering any results that are just new lines, and removing any new lines from the end of the text
    tafseer_sadi_arabic = result.children.reject{|s| s.to_s == "\n"}.map{|r| r.text.strip}
    #produce a simple string to use for replacement
    tafseer_sadi_arabic = tafseer_sadi_arabic.join("\n")
    #run a query on our qur'an database to get the needed text
    arabic_text_tashkeel = qdb.get_first_value( "select aayah_text from quran_marked where surah_no = '#{s_no_str_plain}' and aayah_no = '#{a_no}'" )
    arabic_text_without_tashkeel = qdb.get_first_value( "select aayah_text from quran_clean where surah_no = '#{s_no_str_plain}' and aayah_no = '#{a_no}'" )
    #copy the aayah-sample file into memory
    aayah_sample = File.read("../_sample-files/aayah-sample.tex")
    #replace strings in the sample file
    aayah_sample = aayah_sample.gsub('SN', s_no_str_plain)
    aayah_sample = aayah_sample.gsub('AYN', a_no_str_plain)
    aayah_sample = aayah_sample.gsub('ARABIC_TEXT_TASHKEEL', arabic_text_tashkeel)
    aayah_sample = aayah_sample.gsub('ARABIC_TEXT_WITHOUT_TASHKEEL',  arabic_text_without_tashkeel)
    aayah_sample = aayah_sample.gsub('TAFSEER_SADI_ARABIC', tafseer_sadi_arabic)
    #Put leading zeros on the aayah number
    a_no_str = a_no.to_s.rjust(3, "0")
    #write the file with the newly modified information, and the s_no_str as filename
    File.write("../#{s_no_str}/#{a_no_str}.tex", aayah_sample)
  end
end