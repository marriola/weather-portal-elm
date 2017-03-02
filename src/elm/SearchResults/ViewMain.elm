module SearchResults.ViewMain exposing (view)

import Decoders.Conditions exposing (SearchResult)
import Html exposing (Html, Attribute, label, text, div, input, button, ul, li, a)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import MainTypes exposing (..)
import Util exposing (..)
import HtmlHelper exposing (visible)
import List
import String

view : Model -> Html Msg
view model =
  let
    classNames = [
      Just "panel",
      visible (isNotEmpty model.content.results)
    ]
  in
    div [class (joinClasses classNames)] [
      resultsList model.content.results
    ]


resultsList : Maybe (List SearchResult) -> Html Msg
resultsList list =
  case list of
    Just results ->
      ul [] <| List.map makeItem results

    Nothing ->
      ul [] []

makeItem : SearchResult -> Html Msg
makeItem result =
  li [] [
    a [onClick <| TagContentMsg <| SelectCity ("zmw:" ++ result.zmw)] [
      text (String.join ", " (takeNonEmpty [result.city, result.state, result.country_name]))
    ]
  ]
