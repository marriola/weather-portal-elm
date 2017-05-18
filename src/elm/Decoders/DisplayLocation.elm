module Decoders.DisplayLocation exposing (DisplayLocation, displayLocation)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias DisplayLocation =
  { full : String
  , city : String
  , state : String
  , state_name : String
  , country : String
  , country_iso3166 : String
  , zip : String
  , magic : String
  , wmo : String
  , latitude : String
  , longitude : String
  , elevation : String
  }


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
