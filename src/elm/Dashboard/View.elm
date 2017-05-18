module Dashboard.View exposing (init, view, update)

import Dashboard.ViewMain
import MainTypes exposing (..)
import Decoders.Conditions exposing (Conditions)
import Html exposing (Html)


init : DashboardModel
init =
  {
    search = "",
    scale = US
  }


view : Model -> Html Msg
view model = Dashboard.ViewMain.view model

update : Msg -> Model -> DashboardModel -> (DashboardModel, Cmd Msg)
update msg parentModel model =
  ((case msg of
      TagDashboardMsg (Change str) ->
        { model | search = str }
      TagDashboardMsg (SelectScale scale) ->
        { model | scale = scale }
      TagContentMsg Search ->
        { model | search = "" }
      TagDashboardMsg Reset ->
        { model | search = "" }
      _ ->
        model
    ), Cmd.none)
