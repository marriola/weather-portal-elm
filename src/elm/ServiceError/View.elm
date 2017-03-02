module ServiceError.View exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (..)
import MainTypes exposing (..)

view : Model -> Html Msg
view model =
  case model.content.error of
    Just error ->
      div [class "error"] [text error.description]

    Nothing ->
      div [] []
