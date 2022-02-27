# CS3217 Problem Set 4

**Name:** Gan Hong Yao

**Matric No:** A0217912H

## Tips
1. CS3217's docs is at https://cs3217.github.io/cs3217-docs. Do visit the docs often, as
   it contains all things relevant to CS3217.
2. A Swiftlint configuration file is provided for you. It is recommended for you
   to use Swiftlint and follow this configuration. We opted in all rules and
   then slowly removed some rules we found unwieldy; as such, if you discover
   any rule that you think should be added/removed, do notify the teaching staff
   and we will consider changing it!

   In addition, keep in mind that, ultimately, this tool is only a guideline;
   some exceptions may be made as long as code quality is not compromised.
3. Do not burn out. Have fun!

## Dev Guide
[Go to developer guide](/docs/ps4-developer-guide/DeveloperGuide.md)

## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Cannon Direction
Aiming can be done by either 
- tapping on the desired ball destination or 
- dragging across the screen and releasing the drag action on the desired
ball location.

In both ways, note that the the ball may not end up exactly at the desired
ball destination because of the effects of gravity.

For a more detailed guide on aiming, refer to [this section](#aiming).

### Win and Lose Conditions

(Same as original peggle game, copied from CS3217 website)

To win, clear all orange pegs.

You start with 10 balls. Every time you shoot a ball, the number of balls get subtracted. You lose if you run out of balls and there are still orange pegs remaining in the game.

## Level Designer Additional Features

### Peg Rotation
Use two fingers to do a rotation gesture (see https://docs-assets.developer.apple.com/published/7c21d852b9/0d8b92d2-dbfc-4316-97fd-aa2f6ee22db3.png)

### Peg Resizing
Tap on a peg to select it (orange dot should appear in the middle), then use two fingers to pinch the screen.

### Block rotation
Same as peg rotation.

### Block Resizing
To resize the whole block centered at the current center, tap on the block to select it then use two fingers to pinch the screen.

To move the individual vertices, drag the orange circle on the desired vertex to the desired location.

## Bells and Whistles
Please write all of the additional features that you have implemented so that
your grader can award you credit.

- Score system
- Sound and music
- Display the number of pegs remaining
- Display the number of pegs placed in the level designer
- Game masters
- Additional powerups
  - Increase bucket width
  - Horizontal and vertical "zapper" that lights up pegs in its path
- Multiselect in level designer (Click the multiselect button beside the scroll buttons to enter multi-select mode)
  - Moving selected objects together in a single drag gesture
    - Note: drag gesture must begin at an empty location. If the drag gesture begins from a peg/block, it is assumed that the user is trying to move that object only
  - Rotating selected objects together in a single rotation gesture
  - Resizing selected objects together in a single magnification gesture
  - Note: in the above features, whether an object actually moves/rotates/resizes is independent of other objects - e.g. if only 1 peg is blocked but the other selected objects are not, the other unblocked ones will move without the blocked peg
  - Rectangular select 
    - User can draw a rectangle and any objects partly/wholly in the rectangle will be selected (same as the selection tool in Notability)

## Tests

### Unit tests

- [PhysicsEngine unit tests](https://github.com/cs3217-2122/problem-set-4-ganhongyao/tree/master/PhysicsEngine/Tests/PhysicsEngineTests)
- [PeggleClone unit tests](https://github.com/cs3217-2122/problem-set-4-ganhongyao/tree/master/PeggleClone/PeggleCloneTests)

### Integration tests

#### Testing the main menu
- When the application is launched, the main menu screen should be visible
  - Both the "Create New Level" and "Load Existing Level" buttons should be visible
- When the "Create New Level" button is tapped, the app should navigate to the level designer view
- When the "Load Existing Level" button is tapped, the app should navigate to the level selector view

#### Testing the level selector
- "Design New Level" button should be visible
 - When "Design New Level" button is tapped, the app should navigate to the level designer with a new board
- Previously saved boards should be visible and sorted in lexicographical order
- View should be scrollable when the cards cannot fit on a single view
- Navigation button should be visible
  - When the navigation button is tapped, the app should navigate back to the previous view
##### Testing the board cards
- Snapshot of board (or placeholder image for preloaded levels) should be visible
- Board name should be visible
- Board creation date (or "Preloaded Level" text for preloaded levels) should be visible
- Edit button should be visible
  - When edit button is tapped, the app should navigate to the level designer with the selected board
- Delete button should be visible
  - When delete button is tapped for a non-preloaded level, the card should be removed from the level selector
  - When delete button is tapped for a preloaded level, an alert should be displayed describing that a
    preloaded level cannot be deleted
- Play button should be visible
  - When play button is tapped, the app should navigate to the game view with the selected board
#### Testing the level designer
- When navigated from "Create New Level", the board name and board should be empty
- When navigated from an existing non-preloaded level, the board name should reflect the corresponding name and the board should be filled with the saved pegs and blocks
- When navigated from a preloaded level, the board name should be empty but the board should be filled with the same pegs and blocks as the preloaded level
- Navigation button should be visible
  - When the navigation button is tapped, the app should navigate back to the previous view
##### Testing the level designer controls

- Start button should be visible
  - When start button is tapped, the app should navigate to the game view with the current board layout
- Load button should be visible
  - When load button is tapped, the app should navigate to the level selector
- Save button should be visible
  - When save button is tapped, the current board should be saved
- Reset button should be visible
  - When reset button is tapped, all pegs and blocks should be cleared from the board
- Text field should be visible and display the level name
  - When the text field is tapped, it should enter text edit mode
  - When the text is edited, the text field should update the text accordingly
- If the board native size does not match the screen size exactly, the board should be letterboxed appropriately (i.e.
either the top and bottom or sides fill the available height / width)
##### Testing peg gestures
- When a peg is long pressed for at least 0.5 seconds (and then released), the peg should be removed from the board
- When a peg is dragged ...
  - ... to a position such that the peg is fully within the board **and** there is no overlap with other pegs/blocks, it should move to the new position
  - ... to a position such that peg will be partially/fully outside the board, it should remain at the last valid position
  - ... to a position such that there is some overlap with other pegs/blocks, it should remain at the last valid position
  - ... to a position such that peg will be partially/fully outside the board **and** there is some overlap with other pegs/blocks, it should remain at the last valid position
- When a peg is tapped, the peg should be indicated as selected
- When a peg is selected and a two-finger pinch gesture is applied and the new peg position is valid (see above), the peg should decrease/increase in size
- When a peg is selected and a two-finger pinch gesture is applied and the new peg position is invalid, it should remain at the last valid size
- When a peg is selected and a rotation gesture is applied, the peg should rotate
##### Testing block gestures
- When a block is long pressed for at least 0.5 seconds (and then released), the block should be removed from the board
- When a block is dragged ...
  - ... to a position such that the block is fully within the board **and** there is no overlap with other pegs/blocks, it should move to the new position
  - ... to a position such that block will be partially/fully outside the board, it should remain at the last valid position
  - ... to a position such that there is some overlap with other pegs/blocks, it should remain at the last valid position
  - ... to a position such that block will be partially/fully outside the board **and** there is some overlap with other pegs/blocks, it should remain at the last valid position
- When a block is tapped, the block should be indicated as selected
- When a block is selected and a two-finger pinch gesture is applied and the new block position is valid (see above), the block should decrease/increase in size
- When a block is selected and a two-finger pinch gesture is applied and the new block position is invalid, it should remain at the last valid size
- When a block is selected and a rotation gesture is applied and the new block position is valid, the block should rotate
- When a block is selected and a rotation gesture is applied and the new block position is invalid, the block remain at the last valid orientation
- When a block is selected, the vertices of the block should have indicators
- When a vertex indicator is dragged to a position such that the block is in a valid position, the vertex should move to the new position while other vertices remain at the same positions
- When a vertex indicator is dragged to a position such that the block is in an invalid position, the vertex should remain at the last valid position
##### Testing the peg/block selector
- When a peg button is tapped, the tapped button should be highlighted
- When a peg button is selected and the board is tapped at a valid position (i.e. a peg placed there would be fully within the board and has no overlap with other pegs/blocks), a peg should be created centered at that position
- When a block button is selected and the board is tapped at an invalid position, nothing should happen
- When a block button is selected and the board is tapped at a valid position (i.e. a block placed there would be fully within the board and has no overlap with other pegs/blocks), a block should be created centered at that position
- When a block button is selected and the board is tapped at an invalid position, nothing should happen
- When the delete button is tapped, the delete button should be highlighted
- When the delete button is selected and a peg is tapped, the peg should be removed from the board
- When the delete button is selected and a block is tapped, the block should be removed from the board
- When the delete button is selected and an empty space on the board is tapped, nothing should happen
##### Testing the scroll view
- The scroll up/down buttons should be visible
- When the board is already at the top and the scroll up button is tapped, nothing should happen
- When the scroll down button is tapped, the board should scroll down
- If a peg/block is positioned such that it cannot be displayed at all in the current scroll view, it should not visible
- If a peg/block is positioned such that it can only be displayed partially in the current scroll view, only the partial view should be visible
#### Testing persistence
- When a board is saved, on navigating back to the level selector, the board card should reflect the latest board name and the snapshot should show the latest peg/block placements
  - When the same board card is tapped, it should navigate to the level designer with the latest changes reflected
- When a board is saved, on closing and reopening the app, the board card should reflect the latest board name and the snapshot should show the latest peg placements
- When a board is saved and the level name is empty, it should be saved as "Untitled"

#### Testing the game view
*A fresh game view is defined as the game view that appears when it is first navigated to, before any user action
on the game view.*

- On a fresh game view, the game controls bar should be visible at the top of the screen
- On a fresh game view, the game master selection view should be visible
  - When a game master is tapped, the selection view should dismiss and the game should begin
- If the board native size does not match the screen size exactly, the board should be letterboxed appropriately (i.e.
either the top and bottom or sides fill the available height / width)
- If the board is scrollable, the game view should only show the part of the board where the ball is at
- Navigation button should be visible
  - When the navigation button is tapped, the app should navigate back to the previous view

#### Testing peg/block positions
- the pegs/blocks should be placed in the same relative positions as set out in the level designer. 
- This also means that
  - No peg/block should be overlapping with another peg/block (unless they are being animated
    for removal)
  - All pegs/blocks should be fully within the board
- In addition, all pegs should be below the horizontal line that is drawn across
  the bottom edge of the rectangular frame enclosing the cannon

<a name="aiming">

#### Testing cannon movement and ball launch

Definitions
- *Valid aim point* - a point X on the board such that when a horizontal line 
is drawn across the center of the cannon, X is on or below the horizontal line.
- *Valid aim release point* - a point X on the board such that
  - X is a valid aim point (as defined above) and
  - X is a point that lies outside the rectangular frame enclosing the cannon

Tests
- When there is no ball on the board, the cannon should be fully colored and opaque.
- When there is already an existing ball on the board, the cannon should be translucent
  and greyed out.
- When there is already an existing ball on the board, any attempt to aim and launch the
  ball using a tap gesture or a drag gesture should not launch any new ball.
- When an existing ball leaves the board, the cannon should change from translucent and
  greyed out to fully colored and opaque.
- Using tap gestures for aiming
  - When the screen is tapped on a point that is not a valid aim point, the cannon should
    should launch a ball in the direction of the **last valid aim release point**
  - When the screen is tapped on a valid aim point but not a valid aim release point,
    the cannon should rotate to face the tapped location but not launch a ball
  - When the screen is tapped on a valid aim release point, the cannon should rotate to
    face the tapped location and launch a ball in the direction of the aim release point
- Using drag gestures for aiming
  - On an active drag gesture (i.e. has not been released), the cannon should not launch a ball
  - On an active drag gesture, there should be an 'X' icon overlay on top of the rectangular frame 
    enclosing the cannon
  - On an active drag gesture, if the current point of the drag gesture is a valid aim point, the
    cannon should rotate to face the current point of the drag gesture
  - When a drag gesture ends on the rectangular frame enclosing the cannon, the aiming
    action should end with no ball launched
  - When a drag gesture ends on a valid aim release point, the cannon should launch a ball in the 
    direction of the aim release point
  - When a drag gesture ends on a point that is not a valid aim release point, the cannon should
    launch a ball in the direction of the **last valid aim release point**

</a>

#### Testing the bucket
- When the game begins, the bucket should be centered with regards to the x-axis
- The bucket should oscillate between the left and right boundaries of the screen
- When the bucket collides with the left/right wall, it should move in the opposite direction with
the same speed
- When a ball falls into the bucket, the player should gain one free ball

#### Testing ball movement
- When the ball is in the board, the ball should experience a simulated gravitational force acting
  downwards
- When the ball is in the board and its position overlaps with the position of the cannon, the ball's
  movement should not be affected by the cannon and the ball should pass through on top of the cannon
- The game view should track the position of the ball
- The ball should be visible on the screen at all times

#### Testing interactions between ball and pegs/blocks/bucket
- When the ball collides with a peg/block/bucket, the ball should bounce away in a reasonable manner with a
  slow down in ball velocity but the peg/block/bucket should not respond to the collision
- When the ball collides with an unlit peg, the hit peg should light up
- When the ball collides with a lit peg, the hit peg should remain lit
- When the ball collides with multiple pegs/blocks, the ball should bounce away in a reasonable manner with a
  slow down in ball velocity but the pegs/blocks should not move
- When the ball collides with multiple pegs, the pegs that were unlit should light up and the pegs
  that were lit should remain lit
- When the ball is stuck with no way of reaching the bottom of the screen, any blocking pegs/blocks that are
  in the way should be removed from the board.
- When the ball exits the stage, any lit pegs should be removed from the board.
- When the ball collides with an unlit green peg, the game master's powerup should be applied
  - For a kaboom powerup, nearby pegs should be lit then removed
    - Other pegs that are not nearby should not be affected
  - For a spooky ball powerup, when the ball leaves the stage, it should reappear at the top at the same x-axis
    coordinate

#### Testing animation of peg/block removal
- When a peg/block is removed from the board, the removal should be animated such that the peg first
  sees an increase in size before fading out.

#### Testing interactions between ball and board boundaries
- When the ball collides with the top wall, the ball should bounce away with its horizontal
  velocity unchanged but now move downwards
- When the ball collides with the left wall, the ball should bounce away with its vertical
  velocity unchanged (ignoring the effects of gravity) but now move leftwards
- When the ball collides with the right wall, the ball should bounce away with its vertical
  velocity unchanged (ignoring the effects of gravity) but now move rightwards
- The ball should be able to pass through the bottom of the board and leave the board.

#### Testing game controls
- When the board has not been cleared and the "Leave Game" button is tapped, the application 
  should navigate back to the level designer view of the same board
- When the board has not been cleared and the "Restart Level" button is tapped, the application 
  should
  - Reset the score
  - Reset the ball count
  - Remove any existing balls on the board, if any
  - Replace all removed pegs with new pegs in the same location
  - Replace all lit pegs with unlit pegs in the same location
  - Not change the current aim point of the cannon
  - Bring up the game master selector view

#### Testing the game alert
- When the board is cleared or when the player runs out of balls, the application should bring up a "Level Completed" alert with two
  action buttons, "restart" and "return to level designer"
  - When the "Restart" button is clicked, the application should restart the level with the
    same behaviour as if the "Restart Level" button is tapped and the alert is dismissed
  - When the "Return to level designer" button is clicked, the application should navigate back
    to the view that it came from and the alert is dismissed
- When the board is not cleared, the alert should be hidden

#### Testing compatability with different devices
- When tested with any iPad, the above test plan should still succeed as long as the application
can run on the device.

#### Testing compatability with different screen orientations
- Unfortunately, the above test plan is expected to succeed only in the portrait orientation.
- The application should not be allowed to be enter landscape mode under normal settings.

## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

I think that my design in the previous problem sets were good enough to make PS4
not too painful. Particularly, the use of the MVVM architecture made it clear
which layers should be changed to accommodate which kind of changes.

There was some technical debt that I had to clean. One of them was having to move
the collision resolution logic out of the physics engine and into the game engine.
This is because the game engine should be responsible for handling the collisions,
instead of allowing the physics engine to resolve them automatically after detection.
In some cases, we would want to add game-specific logic when handling collisions.

If I were to redo the entire application, some things that I would have done
differently include the following:
- Modelling physics properties using composition instead of inheritance
  - For example, currently a game peg conforms to the `CircularPhysicsBody`
protocol. This may make it harder to accommodate pegs of different shapes in
future.
- Maintaining a better separation of concerns between the view model and model of 
`GameBoard`
  - Currently, some of the domain logic is handled by the view model, particularly
the behaviour in the `GameBoardViewModel::step` method. Though this was mentioned
in PS3 comments, unfortunately, I did not have the time to fix it before the PS4
deadline.
