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

forecast.each {|key|
    
    daym = key.attributes.to_a[4].to_s
    
        case daym
            when "0"
            tor = "Ночью"
            when "1"
            tor = "Утром"
            when "2"
            tor = "Днём"
            when "3"
            tor = "Вечером"
        end
   
    date_msg = " Дата: #{key.attributes.to_a[0]}. #{key.attributes.to_a[1]}. #{key.attributes.to_a[2]}, #{tor}"
    gradus_msg = " - Температура за бортом: от #{key.elements['TEMPERATURE'].attributes['max']} до #{key.elements['TEMPERATURE'].attributes['min']}"
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
            
    wind_msg = " - Ветер дует с #{dir_wind} со скоростью от #{key.elements['WIND'].attributes['min']} до #{key.elements['WIND'].attributes['max']} м/с"
    pres_msg = " - Давление воздуха от #{key.elements['PRESSURE'].attributes['max']} до #{key.elements['PRESSURE'].attributes['min']}" 
    rellwet_msg = " - Относительная влажность воздуха, в % от #{key.elements['RELWET'].attributes['max']} до #{key.elements['RELWET'].attributes['min']}"
    ocadki = key.elements['PHENOMENA'].attributes['precipitation'].to_i
    maybe = key.elements['PHENOMENA'].attributes['rpower'].to_i   
        case ocadki
            when 3
            ocadki_msg = "смешанные"
            when 4
            ocadki_msg = "дождь"
            when 5
            ocadki_msg = "ливень"
            when 6,7
            ocadki_msg = "снег"
            when 8
            ocadki_msg = "гроза"
            when 9
            ocadki_msg = "нет данных"
            when 10
            ocadki_msg = "без осадков"
        end
    
        case maybe
            when 0
            maybe_msg = "возможно"
            when 1
            maybe_msg = nil
        end

    
    puts "#{date_msg} <br> #{gradus_msg} <br> #{wind_msg} <br> #{pres_msg} \n #{rellwet_msg} \n  - Осадки: #{maybe_msg} #{ocadki_msg}"
    
     }
