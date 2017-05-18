module ContentPanel.ViewMain exposing (view)

import MainTypes exposing (..)
import Decoders.SearchResult exposing (SearchResult)
import Decoders.Conditions exposing (Conditions)
import Decoders.WeatherResponse exposing (WeatherResponse)

import Html exposing (Html, Attribute, label, text, div, span, input, button, ul, li, a, tr)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

import String
import Util exposing (..)
import HtmlHelper exposing (Row, makeTable, makeRow, visible)
import Indicators

view : Model -> Html Msg
view model =
  let
    classNames = [
      Just "content",
      visible (hasContent model.content)
    ]
  in
    span [class (joinClasses classNames)] [
      div [class "panel"] [
        (viewContent model model.content)
      ],
      viewTabStrip model.content.conditions
    ]

tab : Msg -> String -> Html Msg
tab msg title =
  div [class "tab"] [
    a [onClick msg] [text title]
  ]

viewTabStrip : Maybe Conditions -> Html Msg
viewTabStrip maybeConditions =
  case maybeConditions of
    Just conditions ->
      div [class "tabstrip"] [
        tab (TagContentMsg CloseConditions) "Close",
        tab (TagContentMsg (RefreshConditions conditions.key)) "Refresh"
      ]

    Nothing ->
      div [] []

viewContent : Model -> ContentModel -> Html Msg
viewContent parentModel model =
  case model.status of
    Loaded ->
      conditions parentModel.dashboard.scale model.conditions

    Loading ->
      div [class "spinner"] []

    Failed msg ->
      div [class "error"] [text msg]

hasContent : ContentModel -> Bool
hasContent model =
  case model.conditions of
    Just _ -> True
    Nothing -> False

conditions : Scale -> Maybe Conditions -> Html Msg
conditions scale c =
  case c of
    Just conditions ->
      makeTable
        filterRow
        [conditions.display_location.full, conditions.weather]
        [
          ("Temperature", (selectScale scale Indicators.degree (toString conditions.temp_c) (toString conditions.temp_f))),
          ("Humidity", conditions.relative_humidity),
          ("Wind", (selectScale scale Indicators.wind (toString conditions.wind_kph) (toString conditions.wind_mph)) ++ " " ++ conditions.wind_dir),
          ("Dewpoint", (selectScale scale Indicators.degree (toString conditions.dewpoint_c) (toString conditions.dewpoint_f))),
          ("Heat Index", (selectScaleOrDefault scale Indicators.degree conditions.heat_index_c conditions.heat_index_f)),
          ("Wind Chill", (selectScaleOrDefault scale Indicators.degree conditions.windchill_c conditions.windchill_f)),
          ("Feels Like", (selectScaleOrDefault scale Indicators.degree conditions.feelslike_c conditions.feelslike_f)),
          ("Visibility", (selectScale scale Indicators.distance conditions.visibility_km conditions.visibility_mi))
        ]

    Nothing ->
      div [] []

filterRow : Row -> Bool
filterRow row =
  let
    (title, value) = row
  in
    not <| String.startsWith "NA" value
