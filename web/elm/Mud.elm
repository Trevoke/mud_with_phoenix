module App exposing (..)

import Html exposing (Html, h1, text, button, input, form, ul, li, div)
import Html.App

type alias Model =
    {
        input : String,
        logLines : List String
    }

init : ( Model, Cmd Msg )
init =
    let
        model =
            {
              input = ""
            , logLines = ["Test log line"]
            }
    in
        ( model, Cmd.none )

type Msg =
    HelloWorld

view : Model -> Html Msg
view model =
    let
        drawLogLines logLines =
            logLines |> List.map drawLogLine
    in
  div [] [
    ul [] (model.logLines |> drawLogLines),
    form [] [
     input [] [
     ],
     button [] [
       text "Submit"
     ]
    ]
  ]

drawLogLine : String -> Html Msg
drawLogLine logLine =
    li [] [
         text logLine
        ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    HelloWorld ->
      ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

main : Program Never
main =
  Html.App.program
    {
      init = init,
      view = view,
      update = update,
      subscriptions = subscriptions
    }
