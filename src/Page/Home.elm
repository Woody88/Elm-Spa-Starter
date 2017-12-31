module Page.Home exposing (Model, Msg, init, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Data.Session as Session exposing (Session)
import Html exposing (..)
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Views.Page as Page
import Task exposing (Task, succeed)


type alias Model =
    { s : String
    }


init : Session -> Task PageLoadError Model
init session =
    let
        myFunc str =
            { s = str }

        handleLoadError _ =
            pageLoadError Page.Home "Homepage is currently unavailable."
    in
        Task.map Model ("init Home" |> succeed)
            |> Task.mapError handleLoadError



-- VIEW --


view : Session -> Model -> Html Msg
view session model =
    div [] []



-- UPDATE --


type Msg
    = NoOp


update : Session -> Msg -> Model -> ( Model, Cmd Msg )
update session msg model =
    case msg of
        NoOp ->
            model ! []
