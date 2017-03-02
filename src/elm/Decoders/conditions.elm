module Decoders.Conditions exposing (WeatherResponse, WeatherResponseMain, Conditions, SearchResult, WeatherError, weatherResponse)

import Json.Decode exposing (Decoder, field, float, int, list, string, map, maybe, map2, map3, map4, map5, null, oneOf)
import Json.Decode.Pipeline exposing (decode, required, optional)

type alias SearchResult = {
  name : String,
  city : String,
  state : String,
  country : String,
  country_iso3166 : String,
  country_name : String,
  zmw : String,
  l : String
}

type alias Conditions = {
  key : Int,

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

type alias WeatherError = {
  typePrime : String,
  description : String
}

type alias WeatherResponseMain = {
  version : String,
  termsofService : String,
  features : Features,
  results : Maybe (List SearchResult),
  error : Maybe WeatherError
}

type alias WeatherResponse = {
  response : WeatherResponseMain,
  current_observation : Maybe Conditions
}

features : Decoder Features
features =
  decode Features
    |> optional "conditions" int 0

searchResult : Decoder SearchResult
searchResult =
  decode SearchResult
    |> required "name" string
    |> required "city" string
    |> required "state" string
    |> required "country" string
    |> required "country_iso3166" string
    |> required "country_name" string
    |> required "zmw" string
    |> required "l" string

displayLocation : Decoder DisplayLocation
displayLocation =
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

currentObservation : Decoder Conditions
currentObservation =
  decode Conditions
    |> optional "key" int 0
    |> required "display_location" displayLocation
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
decodeConditions = field "current_observation" currentObservation

weatherError : Decoder WeatherError
weatherError =
  decode WeatherError
    |> required "type" string
    |> required "description" string

weatherResponseMain : Decoder WeatherResponseMain
weatherResponseMain =
  map5 WeatherResponseMain
    (field "version" string)
    (field "termsofService" string)
    (field "features" features)
    (maybe (field "results" (list searchResult)))
    (maybe (field "error" weatherError))

weatherResponse : Decoder WeatherResponse
weatherResponse =
  map2 WeatherResponse
    (field "response" weatherResponseMain)
    (maybe (field "current_observation" currentObservation))
