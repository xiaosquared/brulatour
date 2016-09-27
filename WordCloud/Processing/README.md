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

## Movement

### 1. Random Positions
	- Individually addressed words go from predetermined random pattern to grid

### 2. Rain Test
	- Words fall like Rain

### 3. Noise Test
### 4. Noise Test Multi

### Words as French Quarter Houses
Putting previous parts together.

### 1. Polygon Maker
	- A tool to define polygons. Outputs JSON file

### 2. Polygon Parser
 	- A tool to test whether Polygon Maker worked properly
	- Also implemented polygon selection

### 3. Words As House
	- Given a JSON file defining polygons, allows us to select polygons to fill
	- Can also specify color of region

## Water simulation

### 1. Spring Test
	- Models a single vertical spring with damping

### 2. Water Test
 	- A row of springs that behaves like water surface!

### 3. Word Wave
	- Adding words to the surface of the Wave

### 4. Word Wave Letters
	-	letters controlled by individual springs
	- makes the words look like part of the wave, not just floating on the water!

### 5. Word Wave Placing
	- Test for how "gradient of words" will look
	- Click to place random words, lower words will appear smaller

### 6. Many Waves
	- Several independent waves

### 7. Waving Ambient
	- Several waves moving themselves randomly

###	8. Rain in Water
	- Two particle systems! rain + waves that interact

### 9. Splash Particles
	- test for splashing droplets in all directions

### 10. Splashing Rain
	- 3 particle systems that interact: wave, rain, splash
 	- refactored code for managing particles
