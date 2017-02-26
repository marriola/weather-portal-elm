module MainTypes exposing (..)

import Http exposing (..)

import Decoders.Conditions exposing (Conditions, SearchResult, WeatherResponse, WeatherResponseMain, WeatherError)

type Status
  = Loaded
  | Loading
  | Failed String

type DashboardMsg
  = Change String
  | SelectScale Scale

type ContentMsg
  = Search
  | UpdateConditions (Result Http.Error WeatherResponse)
  | SelectCity String
  | LoadCity (String, String, String)

type Msg = TagDashboardMsg DashboardMsg | TagContentMsg ContentMsg

type alias DashboardModel = {
  search : String,
  scale : Scale
}

type alias ContentModel = {
  conditions : Maybe Conditions,
  places : List Conditions,
  results : Maybe (List SearchResult),
  status : Status,
  error : Maybe WeatherError
}

type alias Model = {
  dashboard : DashboardModel,
  content : ContentModel
}

type Scale = Metric | US
