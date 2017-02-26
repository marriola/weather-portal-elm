module Main exposing (..)

import App exposing (..)
import View exposing (view)
import Html exposing (program)
import MainTypes exposing (..)

main : Program Never Model Msg
main =
    program { view = view, init = init, update = update, subscriptions = subscriptions }
