module MainTypes exposing (..)

import Http exposing (..)

import Decoders.Conditions exposing (Conditions)

type Status = Loaded | Loading | Failed String

type DashboardMsg
  = Change String
  | SelectScale Scale

type ContentMsg
  = Search
  | UpdateConditions (Result Http.Error Conditions)

type Msg = TagDashboardMsg DashboardMsg | TagContentMsg ContentMsg

type alias DashboardModel = {
  search : String,
  scale : Scale
}

type alias ContentModel = {
  place : String,
  conditions : Maybe Conditions,
  status : Status
}

type alias Model = {
  dashboard : DashboardModel,
  content : ContentModel
}

type Scale = Metric | US
