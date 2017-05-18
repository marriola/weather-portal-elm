module Decoders.WeatherResponse exposing (WeatherResponse, weatherResponse)

import Decoders.Conditions exposing (Conditions, currentObservation)
import Decoders.SearchResult exposing (SearchResult, searchResult)
import Decoders.WeatherError exposing (WeatherError, weatherError)

import Json.Decode exposing (Decoder, field, oneOf, float, int, list, string, map, maybe, map2, map3, map4, map5, null, oneOf)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias Features =
  { conditions : Int
  }


type alias WeatherResponseInternal =
  { version : String
  , termsofService : String
  , features : Features
  , results : Maybe (List SearchResult)
  , error : Maybe WeatherError
  }


type alias WeatherResponse =
  { response : WeatherResponseInternal
  , current_observation : Maybe Conditions
  }


features : Decoder Features
features =
  decode Features
    |> optional "conditions" int 0


weatherResponseInternal : Decoder WeatherResponseInternal
weatherResponseInternal =
  map5 WeatherResponseInternal
    (field "version" string)
    (field "termsofService" string)
    (field "features" features)
    (maybe (field "results" (list searchResult)))
    (maybe (field "error" weatherError))


weatherResponse : Decoder WeatherResponse
weatherResponse =
  map2 WeatherResponse
    (field "response" weatherResponseInternal)
    (maybe (field "current_observation" currentObservation))
