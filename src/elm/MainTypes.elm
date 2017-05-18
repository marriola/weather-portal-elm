module MainTypes exposing (..)

import Http exposing (..)

import Decoders.SearchResult exposing (SearchResult)
import Decoders.WeatherError exposing (WeatherError)
import Decoders.Conditions exposing (Conditions)
import Decoders.WeatherResponse exposing (WeatherResponse)

type Status
  = Loaded
  | Loading
  | Failed String

type DashboardMsg
  = Change String
  | SelectScale Scale
  | Reset

type ContentMsg
  = Search
  | UpdateConditions (Maybe Int) (Result Http.Error WeatherResponse)
  | CloseConditions
  | RefreshConditions Int
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
  error : Maybe WeatherError,
  nextKey : Int
}

type alias Model = {
  dashboard : DashboardModel,
  content : ContentModel
}

type Scale = Metric | US
