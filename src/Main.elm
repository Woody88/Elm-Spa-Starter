module Main exposing (main)

import Html
import App.State exposing (init, update)
import App.Types exposing (Msg(SetRoute))
import App.View exposing (view)
import Route
import Navigation


main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
