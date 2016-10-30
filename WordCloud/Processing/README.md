# Brulatour "Word Cloud" Project

Notebook of code sketches

## Filling Space

### 1. Filling with Circles
### 2. Filling Polygon with Circles

### 3. Distance Segment Point
### 4. Filling with Rectangles

### 5. Text Width Test
### 6. Filling with Words

### 7. Rectangle Inside Polygon
	- Needs to be refactored for more clarity

### 8. Adjust Polygon
	- Refactored Polygon class
	- Interaction to drag around a polygon's points

### 9. Inside Polygon Rectangles
### 10. Rectangles Inside Polygon
	- version 3 actually works. The others are intermediate failed attempts

### 11. Words Inside Polygon
	- Replace rectangles with words

### Words as French Quarter Houses
	Putting previous parts together.

### 12. Polygon Maker
		- A tool to define polygons. Outputs JSON file

### 13. Polygon Parser
	 	- A tool to test whether Polygon Maker worked properly
		- Also implemented polygon selection

###	14. Word Clusters

### 15. Words As House
		- Given a JSON file defining polygons, allows us to select polygons to fill
		- Can also specify color of region

### 16. Word Clusters Parser
### 17. Word Clusters Animation

## Movement

### 18. Random Positions
	- Individually addressed words go from predetermined random pattern to grid

### 19. Rain Test
	- Words fall like Rain

### 20. Noise Test
### 21. Noise Test Multi

## Water simulation

### 22. Spring Test
	- Models a single vertical spring with damping

### 23. Water Test
 	- A row of springs that behaves like water surface!

### 24. Word Wave
	- Adding words to the surface of the Wave

### 25. Word Wave Letters
	-	letters controlled by individual springs
	- makes the words look like part of the wave, not just floating on the water!

### 26. Word Wave Placing
	- Test for how "gradient of words" will look
	- Click to place random words, lower words will appear smaller

### 27. Many Waves
	- Several independent waves

### 28. Waving Ambient
	- Several waves moving themselves randomly

###	29. Rain in Water
	- Two particle systems! rain + waves that interact

### 30. Splash Particles
	- test for splashing droplets in all directions

(Falling sand is a digression while working on this)

### 31. Splashing Rain
	- 3 particle systems that interact: wave, rain, splash
 	- refactored code for managing particles

### 32. Falling into Wave
	- Objects fall into water, splash, and sink to bottom

### 33. Buoyancy Test
	- Objects that fall into water, splash, and float

### 34. Buoyant Wavy Text
	- Floating text that moves with the waves

### 35. Splashing Rain Words
	- Same as Splashing Rain except everything is rendered as letters!

### 36. Scrolling Text Wave
	- Text that moves along the wave

### 37. Traveling Wave

### 38. Traveling Wave Text
 	- Natural looking ambient waves
	- Many waves + rain + splash + falling text

### 39. Multi Wave
  - Better abstraction for multiple waves

### 40. Unperturbed Wavy Text
  - Fixing issue of jitter when rain is falling down onto a large words

### 41. Wave Scene
	- Final scene!

## Other physics!

### 42. Box2d Test
	- Dropping a bunch of text!
	- Physics engine is a good way to make a word cloud!

### 43. Flocking Test
	- Adapted from Shiffman's code. Word "cloud" flocking around. 	

### 44. Multi House
	- A block of houses. Can translate and scale all of them at once. 
