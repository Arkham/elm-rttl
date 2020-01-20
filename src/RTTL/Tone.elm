module RTTL.Tone exposing (Duration(..), DurationLength(..), Tone(..))

import RTTL.Pitch exposing (Pitch)


type DurationLength
    = Whole
    | Half
    | Quarter
    | Eighth
    | Sixteenth
    | ThirtySecond


type Duration
    = Normal DurationLength
    | Dotted DurationLength


type Tone
    = Tone Pitch Duration
    | Pause Duration
