module Dashboard.View exposing (init, view, update)

import Dashboard.ViewMain
import MainTypes exposing (..)
import Decoders.Conditions exposing (Conditions)
import Html exposing (Html)
import Util exposing (send)


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
  let
    (nextModel, msgOut) =
      case msg of
          TagDashboardMsg (Change str) ->
            ({ model | search = str }, Cmd.none)
          TagDashboardMsg (SelectScale scale) ->
            ({ model | scale = scale }, Cmd.none)
          TagContentMsg Search ->
            ({ model | search = "" }, Cmd.none)
          TagDashboardMsg (KeyDown key) ->
            case key of
              10 -> (model, send <| TagContentMsg Search)
              13 -> (model, send <| TagContentMsg Search)
              _ -> (model, Cmd.none)
          TagDashboardMsg Reset ->
            ({ model | search = "" }, Cmd.none)
          _ ->
            (model, Cmd.none)
  in
    (nextModel, msgOut)
  