module Dashboard.ViewMain exposing (view)

import MainTypes exposing (..)

import Html exposing (Html, Attribute, label, text, div, span, input, button, ul, li, a)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Util exposing (choose)
import Decoders.Conditions exposing (Conditions)


view : Model -> Html Msg
view model =
  let
    isMetric = choose (model.dashboard.scale == Metric) "selected"
    isUS = choose (model.dashboard.scale == US) "selected"
  in
    div [class "dashboard"] [
      a [href "https://github.com/marriola/weather-portal-elm", class "github", target "_blank"] [],

      input [type_ "text", value model.dashboard.search, onInput (TagDashboardMsg << Change)] [],
      button [type_ "button", onClick (TagContentMsg Search), style [("margin-left", "3px")]] [text "Search"],
      button [type_ "button", onClick (TagDashboardMsg Reset)] [text "Reset"],

      nameplates model.content.places
    ]

nameplates : List Conditions -> Html Msg
nameplates places =
  div [] <| List.map makeNameplate places

makeNameplate : Conditions -> Html Msg
makeNameplate c =
  let
    dl = c.display_location
  in
    span [class "panel"] [
      a [onClick (TagContentMsg (LoadCity (dl.city, dl.state, dl.country)))] [text c.display_location.full]
    ]
