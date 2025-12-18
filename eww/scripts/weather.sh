#!/bin/bash

## Collect data
cache_dir="$HOME/.cache/eww/weather"
cache_weather_stat=${cache_dir}/weather-stat
cache_weather_degree=${cache_dir}/weather-degree
cache_weather_hex=${cache_dir}/weather-hex
cache_weather_icon=${cache_dir}/weather-icon

## Weather data
KEY="f986b3d5d9ba8524def85dcf9369a7a9"
ID="3458425"
UNIT="metric"	# Available options : 'metric' or 'imperial'

## Make cache dir
if [[ ! -d "$cache_dir" ]]; then
	mkdir -p ${cache_dir}
fi

## Get data
get_weather_data() {
	weather=`curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID="$KEY"&id="$ID"&units="$UNIT"&lang=pt_br"`
	echo ${weather}

	if [ ! -z "$weather" ]; then
		weather_temp=`echo "$weather" | jq ".main.temp" | cut -d "." -f 1`
		weather_icon_code=`echo "$weather" | jq -r ".weather[].icon" | head -1`
		weather_description=`echo "$weather" | jq -r ".weather[].description" | head -1 | sed -e "s/\b\(.\)/\u\1/g"`

        #Big long if statement of doom
        if [ "$weather_icon_code" == "50d"  ]; then
            weather_icon=""
            weather_hex="#8aadf4"
            elif [ "$weather_icon_code" == "50n"  ]; then
            weather_icon=""
            weather_hex="#8aadf4"
            elif [ "$weather_icon_code" == "01d"  ]; then
            weather_icon=""
            weather_hex="#f5a97f"
            elif [ "$weather_icon_code" == "01n"  ]; then
            weather_icon=""
            weather_hex="#BB9AF7"
            elif [ "$weather_icon_code" == "02d"  ]; then
            weather_icon=""
            weather_hex="#b8c0e0"
            elif [ "$weather_icon_code" == "02n"  ]; then
            weather_icon=""
            weather_hex="#b8c0e0"
            elif [ "$weather_icon_code" == "03d"  ]; then
            weather_icon=""
            weather_hex="#b8c0e0"
            elif [ "$weather_icon_code" == "03n"  ]; then
            weather_icon=""
            weather_hex="#b8c0e0"
            elif [ "$weather_icon_code" == "04d"  ]; then
            weather_icon=""
            weather_hex="#b8c0e0"
            elif [ "$weather_icon_code" == "04n"  ]; then
            weather_icon=""
            weather_hex="#b8c0e0"
            elif [ "$weather_icon_code" == "09d"  ]; then
            weather_icon=""
            weather_hex="#8aadf4"
            elif [ "$weather_icon_code" == "09n"  ]; then
            weather_icon=""
            weather_hex="#8aadf4"
            elif [ "$weather_icon_code" == "10d"  ]; then
            weather_icon=""
            weather_hex="#8aadf4"
            elif [ "$weather_icon_code" == "10n"  ]; then
            weather_icon=""
            weather_hex="#8aadf4"
            elif [ "$weather_icon_code" == "11d"  ]; then
            weather_icon=""
            weather_hex="#f5a97f"
            elif [ "$weather_icon_code" == "11n"  ]; then
            weather_icon=""
            weather_hex="#f5a97f"
            elif [ "$weather_icon_code" == "13d"  ]; then
            weather_icon=""
            weather_hex="#f4dbd6"
            elif [ "$weather_icon_code" == "13n"  ]; then
            weather_icon=""
            weather_hex="#f4dbd6"
            elif [ "$weather_icon_code" == "40d"  ]; then
            weather_icon=""
            weather_hex="#7DCFFF"
            elif [ "$weather_icon_code" == "40n"  ]; then
            weather_icon=""
            weather_hex="#7DCFFF"
        else
            weather_icon=""
            weather_hex="#b8c0e0"

		fi
		echo "$weather_icon" >  ${cache_weather_icon}
		echo "$weather_description" > ${cache_weather_stat}
		echo "$weather_temp""°C" > ${cache_weather_degree}
		echo "$weather_hex" > ${cache_weather_hex}
	else
		echo "Weather Unavailable" > ${cache_weather_stat}
		echo " " > ${cache_weather_icon}
		echo "-" > ${cache_weather_degree}
		echo "#adadff" > ${tcache_weather_hex}
	fi
}

## Execute
if [[ "$1" == "--getdata" ]]; then
	get_weather_data
elif [[ "$1" == "--icon" ]]; then
	cat ${cache_weather_icon}
elif [[ "$1" == "--temp" ]]; then
	cat ${cache_weather_degree}
elif [[ "$1" == "--hex" ]]; then
	tail -F ${cache_weather_hex}
elif [[ "$1" == "--stat" ]]; then
	cat ${cache_weather_stat}
fi