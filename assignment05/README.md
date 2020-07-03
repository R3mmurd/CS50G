# “Legend of Zelda, The Pot Update”

## The goal

- Implement hearts that sometimes drop from enemies at random, which will heal the player for a full heart when picked up (consumed).
  
- Add pots to the game world at random that the player can pick up, at which point their animation will change to reflect them carrying the
  pot. The player should not be able to swing their sword when in this state.

- When carrying a pot, the player should be able to throw the pot. When thrown, the pot will travel in a straight line based on where
  the player is looking. When it collides with a wall, travels more than four tiles, or collides with an enemy, it should disappear.
  When it collides with an enemy, it should do 1 point of damage to that enemy as well.
