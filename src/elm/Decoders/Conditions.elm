module Decoders.Conditions exposing (Conditions, currentObservation)

import Decoders.DisplayLocation exposing (DisplayLocation, displayLocation)

import Json.Decode exposing (Decoder, field, oneOf, float, int, list, string, map, maybe, map2, map3, map4, map5, null, oneOf)
import Json.Decode.Pipeline exposing (decode, required, optional)


maybeFloat : Decoder (Maybe Float)
maybeFloat =
  map (\x -> Just x) float


-- takes a string and converts it into a Maybe Int. the Wunderground API returns
-- "NA" instead of null for some values, these are parsed to Nothing.
stringToFloatDecoder : Decoder (Maybe Float)
stringToFloatDecoder =
  map (\x -> String.toFloat x |> Result.toMaybe) string


type alias Features =
    { conditions : Int
    }


type alias Conditions =
    { key : Int -- set by ContentPanel

    , display_location : DisplayLocation
    , weather : String
    , temp_f : Float
    , temp_c : Float
    , relative_humidity : String
    , wind_dir : String
    , wind_mph : Float
    , wind_kph : Float
    , pressure_mb : String
    , dewpoint_f : Float
    , dewpoint_c : Float
    , heat_index_f : Maybe Float
    , heat_index_c : Maybe Float
    , windchill_f : Maybe Float
    , windchill_c : Maybe Float
    , feelslike_f : Maybe Float
    , feelslike_c : Maybe Float
    , visibility_mi : String
    , visibility_km : String
    , uv : String
    , precip_today_in : String
    , precip_today_metric : String
    }


features : Decoder Features
features =
  decode Features
    |> optional "conditions" int 0


currentObservation : Decoder Conditions
currentObservation =
  let
    floatOrString = oneOf [ maybeFloat, stringToFloatDecoder ]
  in
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
      |> required "heat_index_f" floatOrString
      |> required "heat_index_c" floatOrString
      |> required "windchill_f" floatOrString
      |> required "windchill_c" floatOrString
      |> required "feelslike_f" floatOrString
      |> required "feelslike_c" floatOrString
      |> required "visibility_mi" string
      |> required "visibility_km" string
      |> required "UV" string
      |> required "precip_today_in" string
      |> required "precip_today_metric" string
