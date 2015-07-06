require 'open-uri'
require 'sqlite3'

#open the quran.com database from https://github.com/quran/quran.com-images
db = SQLite3::Database.new( "text.sqlite3.db" )

#run a query that produces a list of surah numbers (1-114), with the last aayah for each one
#then for each row within the results...
db.execute( "select sura, max(ayah) from sura_ayah_page_text group by sura" ) do |row|
  #set the surah number to s_no, and the last aayah to max_a_no
  s_no = row[0]
  max_a_no = row[1]
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
