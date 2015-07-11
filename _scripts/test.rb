#a simple script for testing certain things

require 'nokogiri'

#some dummy content that mimics the structure of the web page
dummy_content = '<div id="div_saadi"><div><div style="padding:10px 0">
<span class="t4">content</span>content outside of the span<span class="t2">morecontent</span>morecontent outside of the span
</div></div></div>'
page = Nokogiri::HTML(dummy_content)
#grab the second div inside of the div entitled div_saadi
result = page.css('div#div_saadi div')[1]
#go through the child nodes in the result, one by one, filtering any results that are just new lines, and removing any new lines from the end of the text
tafseer_sadi_arabic = result.children.reject{|s| s.to_s == "\n"}.map{|r| r.text.strip}
aayah_sample = "TAFSEER_SADI_ARABIC"
puts aayah_sample
aayah_sample = aayah_sample.gsub('TAFSEER_SADI_ARABIC', tafseer_sadi_arabic.join("\n"))
puts aayah_sample