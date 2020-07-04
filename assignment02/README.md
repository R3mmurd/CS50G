# “Breakout, The Powerup Update”

## The goal

- Add a Powerup class to the game that spawns a powerup. This Powerup should spawn randomly,
  be it on a timer or when the Ball hits a Block enough times, and gradually descend toward the
  player. Once collided with the Paddle, two more Balls should spawn and behave identically to
  the original, including all collision and scoring points for the player. Once the player
  wins and proceeds to the VictoryState for their current level, the Balls should reset so that
  there is only one active again.

- Grow and shrink the Paddle such that it’s no longer just one fixed size forever. In particular,
  the Paddle should shrink if the player loses a heart (but no smaller of course than the smallest
  paddle size) and should grow if the player exceeds a certain amount of score (but no larger than
  the largest Paddle).

- Add a locked Brick to the level spawning, as well as a key powerup. The locked Brick should not be
  breakable by the ball normally, unless they of course have the key Powerup! The key Powerup should
  spawn randomly just like the Ball Powerup and descend toward the bottom of the screen just the same,
  where the Paddle has the chance to collide with it and pick it up. Not every level needs to have locked
  Bricks; just include them occasionally! Perhaps make them worth a lot more points as well in order to
  compel their design.

## Demo

<a href="http://www.youtube.com/watch?feature=player_embedded&v=-vvZcQcqnBs
" target="_blank"><img src="http://img.youtube.com/vi/-vvZcQcqnBs/0.jpg"
alt="Demo Breakout" width="240" height="180" border="10" /></a>
