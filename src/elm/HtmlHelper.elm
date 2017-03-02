module HtmlHelper exposing (..)

import MainTypes exposing (Msg)
import Html exposing (Html, table, thead, tbody, tr, td, th, text)
import Html.Attributes exposing (..)
import Util exposing (orNothing)
import List

makeTable : (Row -> Bool) -> List String -> List Row -> Html Msg
makeTable filter headers rows =
  table [] [
    thead [] <| List.map makeHeader headers,
    tbody [] (rows |> List.filter filter |> List.map makeRow)
  ]

type alias Row = (String, String)

makeHeader : String -> Html Msg
makeHeader title =
  tr [] [
    th [attribute "colspan" "2"] [text title]
  ]

makeRow : Row -> Html Msg
makeRow row =
  let
    (title, content) = row
  in
    tr [] [
      td [class "header left"] [text title],
      td [] [text content]
    ]

visible : Bool -> Maybe String
visible condition =
  orNothing condition "hidden"
