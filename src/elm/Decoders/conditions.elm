module Decoders.Conditions exposing (Conditions, decodeConditions)

import Json.Decode exposing (Decoder, int, float, string, field)
import Json.Decode.Pipeline exposing (decode, required, optional)

type alias Conditions = {
  display_location : DisplayLocation,
  weather : String,
  temp_f : Float,
  temp_c : Float,
  relative_humidity : String,
  wind_dir : String,
  wind_mph : Float,
  wind_kph : Float,
  pressure_mb : String,
  dewpoint_f : Float,
  dewpoint_c : Float,
  heat_index_f : String,
  heat_index_c : String,
  windchill_f : String,
  windchill_c : String,
  feelslike_f : String,
  feelslike_c : String,
  visibility_mi : String,
  visibility_km : String,
  uv : String,
  precip_today_in : String,
  precip_today_metric : String
}

type alias DisplayLocation = {
  full : String,
  city : String,
  state : String,
  state_name : String,
  country : String,
  country_iso3166 : String,
  zip : String,
  magic : String,
  wmo : String,
  latitude : String,
  longitude : String,
  elevation : String
}

type alias Features = {
  conditions : Int
}

type alias WeatherResponse = {
  version : String,
  termsofService : String,
  features : Features
}

decodeFeatures : Decoder Features
decodeFeatures =
  decode Features
    |> optional "conditions" int 0

decodeWeatherResponse : Decoder WeatherResponse
decodeWeatherResponse =
  decode WeatherResponse
    |> required "version" string
    |> required "termsofService" string
    |> required "features" decodeFeatures

decodeDisplayLocation : Decoder DisplayLocation
decodeDisplayLocation =
  decode DisplayLocation
    |> required "full" string
    |> required "city" string
    |> required "state" string
    |> required "state_name" string
    |> required "country" string
    |> required "country_iso3166" string
    |> required "zip" string
    |> required "magic" string
    |> required "wmo" string
    |> required "latitude" string
    |> required "longitude" string
    |> required "elevation" string

decodeCurrentObservation : Decoder Conditions
decodeCurrentObservation =
  decode Conditions
    |> required "display_location" decodeDisplayLocation
    |> required "weather" string
    |> required "temp_f" float
    |> required "temp_c" float
    |> required "relative_humidity" string
    |> required "wind_dir" string
    |> required "wind_mph" float
    |> required "wind_kph" float
    |> required "pressure_mb" string
    |> required "dewpoint_f" float
    |> required "dewpoint_c" float
    |> required "heat_index_f" string
    |> required "heat_index_c" string
    |> required "windchill_f" string
    |> required "windchill_c" string
    |> required "feelslike_f" string
    |> required "feelslike_c" string
    |> required "visibility_mi" string
    |> required "visibility_km" string
    |> required "UV" string
    |> required "precip_today_in" string
    |> required "precip_today_metric" string

decodeConditions : Decoder Conditions
decodeConditions = field "current_observation" decodeCurrentObservation