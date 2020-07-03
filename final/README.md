# “Final Fifty, the final project”

## The goal

- Create a full game from scratch using either LÖVE or Unity.

## From Start to Finish

1) The game must be in either LÖVE or Unity.

2) The game must be a cohesive start-to-finish experience for the user; the game should boot up, allow
   the user to play toward some end goal, and feature a means of quitting the game.

3) The game should have at least three GameStates to separate the flow of your game’s user experience,
   even if it’s as simple as a StartState, a PlayState, and an EndState, though you’re encouraged to implement
   more as needed to suit a more robust game experience (e.g., a fantasy game with a MenuState or even a separate CombatState).

4) The game can be most any genre you’d like, though there needs to be a definitive way of winning
   (or at least scoring indefinitely) and losing the game, be it against the computer or another player.
   This can take many forms; some loss conditions could be running out of time in a puzzle game, being slain
   by monsters in an RPG, and so on, while some winning conditions may be defeating a final boss in an RPG,
   making it to the end of a series of levels in a platformer, and tallying score in a puzzle game until it
   becomes impossible to do more.

5) I was allowed to use libraries and assets in either game development environment, but the bulk
   of your game’s logic must be handwritten (i.e., putting together an RPG in Unity while using a UI
   library would be considered valid, assuming the bulk of the game logic is also not implemented in a library,
   but recycling a near-complete game prototype from Unity’s asset store with slightly changed labels, materials,
   etc. would not be acceptable).

6) The project must be at least as complex as the games you’ve implemented in this course, and should really be moreso.
   Submissions of low complexity may be rejected!

## The Game

This is an RPG based on Final Fantasy. The player builds a party by choosing between a male or female character
to each of the vocations (warrior, ranger, healer, and mage). There are five regions, the center that is the town
where the player is safe. In that region, there are some NPCs who tell something to the player. The north region contains
the weakest creatures to hunt. The south region contains a little stronger creatures to hunt than the norths. The east region
contains stronger creatures to hunt than the souths. Finally, the west region contains the strongest creatures
to hunt and the final boss.

The goal is to hunt creatures from the weakest to the strongest to level up each of the party characters and go to defeat
to the final boss to end the game. If all of the characters of the party die, then the game is over and the player will
have to start again from the beginning.

## Credits

- In this game were used some of the source codes, images, fonts, and sounds from previous assignments.
  
- Other of the images and sounds were downloaded from https://opengameart.org/.

- The Final Fantasy font was downloaded from https://www.dafont.com/final-fantasy.font.
