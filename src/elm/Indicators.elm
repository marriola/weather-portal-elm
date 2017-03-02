module Indicators exposing (..)

import MainTypes exposing (..)

degree : Scale -> String
degree scale =
  case scale of
    Metric  -> "ºC"
    US      -> "ºF"

distance : Scale -> String
distance scale =
  case scale of
    Metric  -> "km"
    US      -> "mi"

wind : Scale -> String
wind scale =
  case scale of
    Metric  -> "kph"
    US      -> "mph"
