# “Dreadhalls, The Tumble Update”

## The goal

- Spawn holes in the floor of the maze that the player can fall through (but not too many;
  just three or four per maze is probably sufficient, depending on maze size).

- When the player falls through any holes, transition to a “Game Over” screen similar to the Title Screen,
  implemented as a separate scene. When the player presses “Enter” in the “Game Over” scene, they should
  be brought back to the title.

- Add a Text label to the Play scene that keeps track of which maze they’re in, incrementing each time they
  progress to the next maze. This can be implemented as a static variable, but it should be reset to 0 if they get a Game Over.

## Demo

<a href="http://www.youtube.com/watch?feature=player_embedded&v=kHQnL7iI2ZU
" target="_blank"><img src="http://img.youtube.com/vi/kHQnL7iI2ZU/0.jpg"
alt="Demo Dreadhalls" width="240" height="180" border="10" /></a>
