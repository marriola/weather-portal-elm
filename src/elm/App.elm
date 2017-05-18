module App exposing (..)

import MainTypes exposing (..)
import Dashboard.View
import ContentPanel.View


init : (Model, Cmd Msg)
init =
    ( {
      dashboard = Dashboard.View.init,
      content = ContentPanel.View.init
    }, Cmd.none )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    TagContentMsg cmsg ->
      let
        (newContent, msgOut) = ContentPanel.View.update msg model model.content
        primaryModel = { model | content = newContent }
        (newDashboard, _) = Dashboard.View.update msg model model.dashboard
        finalModel = { primaryModel | dashboard = newDashboard }
      in
        (finalModel, msgOut)

    TagDashboardMsg dmsg ->
      let
        (newDashboard, msgOut) = Dashboard.View.update msg model model.dashboard
        primaryModel = { model | dashboard = newDashboard }
        (newContent, _) = ContentPanel.View.update msg model model.content
        finalModel = { primaryModel | content = newContent }
      in
        (finalModel, msgOut)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
