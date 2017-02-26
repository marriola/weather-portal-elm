module Dashboard.View exposing (view, update)

import Dashboard.ViewMain
import MainTypes exposing (..)
import Decoders.Conditions exposing (Conditions)
import Html exposing (Html)

view : Model -> Html Msg
view model = Dashboard.ViewMain.view model

update : DashboardMsg -> Model -> DashboardModel -> (DashboardModel, Cmd Msg)
update msg parentModel model =
  ((case msg of
      Change str ->
        { model | search = str }
      SelectScale scale ->
        { model | scale = scale }
    ), Cmd.none)
