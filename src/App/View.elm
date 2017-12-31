module App.View exposing (..)

import Data.Session exposing (Session)
import Html exposing (..)
import App.Types exposing (..)
import Page.NotFound as NotFound
import Page.Errored as Errored
import Page.Home as Home
import Views.Page as Page


-- VIEW --


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage model.session False page

        TransitioningFrom page ->
            viewPage model.session True page


viewPage : Session -> Bool -> Page -> Html Msg
viewPage session isLoading page =
    let
        frame =
            Page.frame isLoading session.user
    in
        case page of
            NotFound ->
                NotFound.view session
                    |> frame Page.Other

            Blank ->
                -- This is for the very initial page load, while we are loading
                -- data via HTTP. We could also render a spinner here.
                Html.text ""
                    |> frame Page.Other

            Errored subModel ->
                Errored.view session subModel
                    |> frame Page.Other

            Home subModel ->
                Home.view session subModel
                    |> frame Page.Home
                    |> Html.map HomeMsg



-- Login subModel ->
--     Login.view session subModel
--         |> frame Page.Other
--         |> Html.map LoginMsg
--
-- Register subModel ->
--     Register.view session subModel
--         |> frame Page.Other
--         |> Html.map RegisterMsg
