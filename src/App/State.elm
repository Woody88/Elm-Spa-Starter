module App.State exposing (..)

import Data.Session as Session exposing (Session)
import Data.User as User exposing (User, Username)
import App.Types exposing (..)
import Route exposing (Route)
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Errored as Errored exposing (PageLoadError)
import Task
import Util exposing ((=>))
import Json.Decode as Decode exposing (Value)
import Navigation exposing (Location)
import Ports
import Views.Page as Page exposing (ActivePage)


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded initialPage
        , session = { user = decodeUserFromJson val }
        }


initialPage : Page
initialPage =
    Blank


decodeUserFromJson : Value -> Maybe User
decodeUserFromJson json =
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString User.decoder >> Result.toMaybe)


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        transition toMsg task =
            { model | pageState = TransitioningFrom (getPage model.pageState) }
                => Task.attempt toMsg task

        errored =
            pageErrored model
    in
        case maybeRoute of
            Nothing ->
                { model | pageState = Loaded NotFound } => Cmd.none

            Just Route.Home ->
                transition HomeLoaded (Home.init model.session)



-- Just Route.Login ->
--     { model | pageState = Loaded (Login Login.initialModel) } => Cmd.none
--
-- Just Route.Logout ->
--     let
--         session =
--             model.session
--     in
--         { model | session = { session | user = Nothing } }
--             => Cmd.batch
--                 [ Ports.storeSession Nothing
--                 , Route.modifyUrl Route.Home
--                 ]
--
-- Just Route.Register ->
--     { model | pageState = Loaded (Register Register.initialModel) } => Cmd.none


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ pageSubscriptions (getPage model.pageState)
        , Sub.map SetUser sessionChange
        ]


sessionChange : Sub (Maybe User)
sessionChange =
    Ports.onSessionChange (Decode.decodeValue User.decoder >> Result.toMaybe)


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none

        Errored _ ->
            Sub.none

        NotFound ->
            Sub.none

        Home _ ->
            Sub.none



--
-- Login _ ->
--     Sub.none
--
-- Register _ ->
--     Sub.none


pageErrored : Model -> ActivePage -> String -> ( Model, Cmd msg )
pageErrored model activePage errorMessage =
    let
        error =
            Errored.pageLoadError activePage errorMessage
    in
        { model | pageState = Loaded (Errored error) } => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    let
        session =
            model.session

        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
                ( { model | pageState = Loaded (toModel newModel) }, Cmd.map toMsg newCmd )

        errored =
            pageErrored model
    in
        case ( msg, page ) of
            ( SetRoute route, _ ) ->
                setRoute route model

            ( SetUser user, _ ) ->
                let
                    session =
                        model.session

                    cmd =
                        -- If we just signed out, then redirect to Home.
                        if session.user /= Nothing && user == Nothing then
                            Route.modifyUrl Route.Home
                        else
                            Cmd.none
                in
                    { model | session = { session | user = user } }
                        => cmd

            ( HomeLoaded (Ok subModel), _ ) ->
                { model | pageState = Loaded (Home subModel) } => Cmd.none

            ( HomeLoaded (Err error), _ ) ->
                { model | pageState = Loaded (Errored error) } => Cmd.none

            ( HomeMsg subMsg, Home subModel ) ->
                toPage Home HomeMsg (Home.update session) subMsg subModel

            ( _, NotFound ) ->
                -- Disregard incoming messages when we're on the
                -- NotFound page.
                model => Cmd.none

            ( _, _ ) ->
                -- Disregard incoming messages that arrived for the wrong page
                model => Cmd.none



--
-- ( LoginMsg subMsg, Login subModel ) ->
--     let
--         ( ( pageModel, cmd ), msgFromPage ) =
--             Login.update subMsg subModel
--
--         newModel =
--             case msgFromPage of
--                 Login.NoOp ->
--                     model
--
--                 Login.SetUser user ->
--                     let
--                         session =
--                             model.session
--                     in
--                         { model | session = { user = Just user } }
--     in
--         { newModel | pageState = Loaded (Login pageModel) }
--             => Cmd.map LoginMsg cmd
--
-- ( RegisterMsg subMsg, Register subModel ) ->
--     let
--         ( ( pageModel, cmd ), msgFromPage ) =
--             Register.update subMsg subModel
--
--         newModel =
--             case msgFromPage of
--                 Register.NoOp ->
--                     model
--
--                 Register.SetUser user ->
--                     let
--                         session =
--                             model.session
--                     in
--                         { model | session = { user = Just user } }
--     in
--         { newModel | pageState = Loaded (Register pageModel) }
--             => Cmd.map RegisterMsg cmd
