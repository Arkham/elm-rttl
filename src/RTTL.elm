module RTTL exposing (BPM(..), Ringtone(..), parseComposer)

import Parser as P exposing ((|.), (|=), Parser)
import RTTL.Note exposing (Note(..))
import RTTL.Pitch exposing (Pitch(..))
import RTTL.Tone exposing (Duration(..), DurationLength(..), Tone(..))


type BPM
    = BPM Int


type Ringtone
    = Ringtone
        { tempo : BPM
        , tones : List Tone
        }


parseComposer : { tempo : Int } -> String -> Result (List P.DeadEnd) Ringtone
parseComposer { tempo } input =
    P.run composerParser input
        |> Result.map
            (\tones ->
                Ringtone { tempo = BPM tempo, tones = tones }
            )


composerParser : Parser (List Tone)
composerParser =
    P.loop [] composerParserHelper


composerParserHelper : List Tone -> Parser (P.Step (List Tone) (List Tone))
composerParserHelper acc =
    P.oneOf
        [ P.succeed (\v -> P.Loop (v :: acc))
            |. P.spaces
            |= composerToneParser
            |. P.spaces
        , P.succeed (P.Done (List.reverse acc))
        ]


composerToneParser : Parser Tone
composerToneParser =
    P.oneOf
        [ P.backtrackable <|
            P.succeed (\duration pitch -> Tone pitch duration)
                |= durationParser
                |= pitchParser
        , P.succeed Pause
            |= durationParser
            |. P.symbol "-"
        ]


pitchParser : Parser Pitch
pitchParser =
    let
        octaveParser =
            P.oneOf
                [ P.succeed 1
                    |. P.symbol "1"
                , P.succeed 2
                    |. P.symbol "2"
                , P.succeed 3
                    |. P.symbol "3"
                ]
    in
    P.succeed Pitch
        |= noteParser
        |= octaveParser


noteParser : Parser Note
noteParser =
    P.oneOf
        [ withSharp "a" ( A, Bb )
        , withSharp "b" ( B, C )
        , withSharp "c" ( C, Db )
        , withSharp "d" ( D, Eb )
        , withSharp "e" ( E, F )
        , withSharp "f" ( F, Gb )
        , withSharp "g" ( G, Ab )
        ]


withSharp : String -> ( Note, Note ) -> Parser Note
withSharp note ( current, sharped ) =
    P.backtrackable <|
        P.oneOf
            [ P.succeed sharped
                |. P.symbol "#"
                |. P.symbol note
            , P.succeed current
                |. P.symbol note
            ]


durationParser : Parser Duration
durationParser =
    let
        durationLengthParser =
            P.oneOf
                [ P.succeed ThirtySecond
                    |. P.symbol "32"
                , P.succeed Sixteenth
                    |. P.symbol "16"
                , P.succeed Eighth
                    |. P.symbol "8"
                , P.succeed Quarter
                    |. P.symbol "4"
                , P.succeed Half
                    |. P.symbol "2"
                , P.succeed Whole
                ]
    in
    P.oneOf
        [ P.backtrackable
            (P.succeed Dotted
                |= durationLengthParser
                |. P.symbol "."
            )
        , P.succeed Normal
            |= durationLengthParser
        ]
