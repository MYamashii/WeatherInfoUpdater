require_relative 'city_id_reader'
require_relative 'current_weather'
require_relative 'current_weather_list'
require 'json'
require 'open-uri'

class CurrentWeathersGetter
  BASE_URL = 'http://api.openweathermap.org/data/2.5/weather'  

  def get_weather(city_id)
    api_key = ENV['OPENWEATHERMAP_API_KEY']
    response = open(BASE_URL + "?id=#{city_id}&APPID=#{api_key}")

    location_weather = JSON.parse(response.read)

    current_weather = CurrentWeather.new
    current_weather.longitude = location_weather['coord']['lon']
    current_weather.latitude = location_weather['coord']['lat']
    current_weather.city_id = location_weather['id']
    current_weather.city_name = location_weather['name']

    current_weather.weather_group_id = location_weather['weather'][0]['id']
    current_weather.weather_icon = location_weather['weather'][0]['icon']
    current_weather.weather_main = location_weather['weather'][0]['main']
    current_weather.weather_description = location_weather['weather'][0]['description']

    current_weather.temperature = location_weather['main']['temp']
    current_weather.pressure = location_weather['main']['pressure']
    current_weather.humidity = location_weather['main']['humidity']
    current_weather.temperature_min = location_weather['main']['temp_min']
    current_weather.temperature_max = location_weather['main']['temp_max']
    current_weather.wind_speed = location_weather['wind']['speed']
    current_weather.wind_degree = location_weather['wind']['deg']
    current_weather.cloudiness = location_weather['clouds']['all']

    if location_weather.key?('rain')
      if location_weather['rain'].key?('1h')
        current_weather.rain_1h = location_weather['rain']['1h']
      end
      if location_weather['rain'].key?('3h')
        current_weather.rain_3h = location_weather['rain']['3h']
      end
    end

    if location_weather.key?('snow')
      if location_weather['snow'].key?('1h')
        current_weather.snow_1h = location_weather['snow']['1h']
      end
      if location_weather['snow'].key?('3h')
        current_weather.snow_3h = location_weather['snow']['3h']
      end
    end

    current_weather.sunrise = location_weather['sys']['sunrise']
    current_weather.sunset = location_weather['sys']['sunset']
    current_weather.country_code = location_weather['sys']['country']

    return current_weather
  end

  def get_city_id_list
    reader = CityIdReader.new
    city_list = reader.read_city_id
    return city_list
  end

  def get_weathers
    city_id = '1854345'
    weather = get_weather(city_id)
    weather_list = CurrentWeatherList.new
    weather_list.add(weather)
    return weather_list
  end
end
