module Events.KeyDown exposing (onKeyDown)

import Html exposing (Attribute)
import Html.Events exposing (on, keyCode)
import Json.Decode


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  on "keydown" (Json.Decode.map tagger keyCode)
