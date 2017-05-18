module Decoders.SearchResult exposing (SearchResult, searchResult)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias SearchResult =
  { name : String
  , city : String
  , state : String
  , country : String
  , country_iso3166 : String
  , country_name : String
  , zmw : String
  , l : String
  }


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
