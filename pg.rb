require 'net/http' # Send a requiest to the web
require 'uri' # to work url
require 'rexml/document' # xml parse

uri = URI.parse('https://xml.meteoservice.ru/export/gismeteo/point/10.xml')
response = Net::HTTP.get_response(uri)

# Парсим данные

doc = REXML::Document.new(response.body)
city = doc.root.elements['REPORT/TOWN'].attributes['sname']
name = URI.unescape(city)
#Данные о погоде лежат в forecast. Этих форкатостов несколько. По этому берем все форкасты как элемент и запихиваем в массив
forecast = doc.root.elements['REPORT/TOWN'].elements.to_a


puts "Прогноз погоды (Возможно не точно)"
puts "------#{name} ------"



forecast.each {|key|
   puts
    puts " Дата: #{key.attributes.to_a[0]},#{key.attributes.to_a[1]},#{key.attributes.to_a[2]}"
    
    puts " - Температура за бортом: от #{key.elements['TEMPERATURE'].attributes['max']} до #{key.elements['TEMPERATURE'].attributes['min']}"
    
    direction = key.elements['WIND'].attributes['direction'].to_i
    
    case direction 
        when 0 
    dir_wind = "севера"
        when 1 
    dir_wind = "северо-востока"
        when 2 
    dir_wind = "востока"
        when 3 
    dir_wind = "юго-востока"
        when 4 
    dir_wind = "юга"
        when 5 
    dir_wind = "юго-запада"
        when 6 
    dir_wind = "запада"
        else 
    dir_wind = "северо-запада"            
    end
            
    puts " - Ветер дует с #{dir_wind} со скоростью от #{key.elements['WIND'].attributes['min']} до #{key.elements['WIND'].attributes['max']} м/с"
    
    }