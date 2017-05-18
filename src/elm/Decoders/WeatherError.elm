module Decoders.WeatherError exposing (WeatherError, weatherError)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias WeatherError =
  { typePrime : String
  , description : String
  }


weatherError : Decoder WeatherError
weatherError =
  decode WeatherError
    |> required "type" string
    |> required "description" string