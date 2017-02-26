module App exposing (..)

import Maybe exposing (..)
import Http exposing (..)
import Decoders.Conditions exposing (Conditions, decodeConditions)

import MainTypes exposing (..)
import View exposing (view)
import Dashboard.View
import ContentPanel.View

init : (Model, Cmd Msg)
init =
    ( {
      dashboard = {
        search = "",
        scale = US
      },
      content = {
        place = "",
        conditions = Nothing,
        status = Loaded
      }
    }, Cmd.none )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    TagContentMsg cmsg ->
      let
        (newContent, msg) = ContentPanel.View.update cmsg model model.content
      in
        ({ model | content = newContent }, msg)

    TagDashboardMsg dmsg ->
      let
        (newDashboard, msg) = Dashboard.View.update dmsg model model.dashboard
      in
        ({ model | dashboard = newDashboard }, msg)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
