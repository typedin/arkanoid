Capsule type is predetermined at specific bricks per level, but those exact positions aren't publicly documented.
Silver/gold bricks don't drop capsules.
Early/mid levels have the most capsule bricks; late levels far fewer.
Fans haven't documented a full level‑by‑capsule breakdown, so your best bet is firsthand observation or fandom collaboration.

# READINGS
- [ ] (see)[https://github.com/Sheepolution/lekker-spelen-origins]

# DOING
- [ ] the ball sometimes goes beyond the paddle and is stuck there

# BUGS
- [ ] collision bug: golden bricks (level 2)
- [ ] collision with 2 bricks at the same time
- [ ] hide the paddle's portion that is outside the live area
- [ ] bug if I use the live height it freezes the game <-- ????????????????????????????????
- [ ] bricks layout is buggy: weird margin to the right most brick
- [ ] is ball dx acceptable?

# TODO
- [ ] better physics for speed_up and slow_down (this +50 or -50 is weird)
- [ ] power-ups add: superball
- [ ] bonuses (extra lives, extra points, weapons)
- [ ] title area 
- [ ] credits area
- [ ] game over screen one per player
- [ ] a level may have a fixed amount of bonuses and they are assigned randomly
- [ ] (physics)[https://www.love2d.org/wiki/love.physics]
- [ ] levels (see)[https://www.mobygames.com/game/1087/arkanoid/screenshots/]
- [ ] save scores
- [ ] State machine
- [ ] Add a game over screen
- [ ] Add a pause screen
- [ ] Add sound effects
- [ ] create music
- [ ] sprites for wall, paddle, ball
- [ ] font for score
- [ ] add rotation to ball ?
- [ ] todo difficulties? -> ball speed

# DONE
- [x] with 3 balls, the additional balls should have different dx 
- [x] with 3 balls, the paddle moves faster <-- WARNING not sure about this
- [x] multi player (2)
- [x] on game load / new life / new level, put the paddle at the center
- [x] add timer to power-ups
- [x] when the B power_up is hit, move the paddle out (the mechanics is already implemented in game_states)
- [x] when the level is complete open a door and move the paddle out of the live area
- [x] if a player has a catch ball power up the ball should stick to the paddle until it times up <------ THE PADDLE SHOULD BE STICKY (so I can change the sprite if needed)
