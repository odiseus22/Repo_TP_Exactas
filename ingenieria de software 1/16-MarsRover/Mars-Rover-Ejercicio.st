!classDefinition: #MarsTest category: 'Mars-Rover-Ejercicio'!
TestCase subclass: #MarsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars-Rover-Ejercicio'!

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:27:42'!
test01DoingNothingKeepsDirectionAndPosition
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: (North).
	aRover interpretPackage: ''.
	self assert: 3@4 equals: aRover position.
	self assert: North equals: aRover facing.! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:28:31'!
test02fowardNorthGoesNorth
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: North.
	aRover interpretPackage: 'f'.
	self assert: 3@5 equals: aRover position.
	self assert: North equals: aRover facing.! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:29:05'!
test03backNorthGoesSouth
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: North.
	aRover interpretPackage: 'b'.
	self assert: 3@3 equals: aRover position.
	self assert: North equals: aRover facing.! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:29:44'!
test04rightOnNorthRotatesToEast
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: North.
	aRover interpretPackage: 'r'.
	self assert: 3@4 equals: aRover position.
	self assert: East equals: aRover facing.! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:30:09'!
test05leftOnNortRotatesToWest
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: North.
	aRover interpretPackage: 'l'.
	self assert: 3@4 equals: aRover position.
	self assert: West equals: aRover facing.! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:30:36'!
test06leftOnSouthRotatesToEast
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: South.
	aRover interpretPackage: 'l'.
	self assert: 3@4 equals: aRover position.
	self assert: East equals: aRover facing.
	! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:30:57'!
test07leftOnEastRotatesToNorth
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: East.
	aRover interpretPackage: 'l'.
	self assert: 3@4 equals: aRover position.
	self assert: North equals: aRover facing.
	! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:31:17'!
test08rightOnEastRotatesToSouth
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: East.
	aRover interpretPackage: 'r'.
	self assert: 3@4 equals: aRover position.
	self assert: South equals: aRover facing.
	! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:31:35'!
test09rightOnWestRotatesToNorth
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: West.
	aRover interpretPackage: 'r'.
	self assert: 3@4 equals: aRover position.
	self assert: North equals: aRover facing.
	! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:31:52'!
test10leftOnWestRotatesToSouth
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: West.
	aRover interpretPackage: 'l'.
	self assert: 3@4 equals: aRover position.
	self assert: South equals: aRover facing.
	! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:50:35'!
test11fowardOnSouthGoesDown
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: South.
	aRover interpretPackage: 'f'.
	self assert: 3@3 equals: aRover position.
	self assert: South equals: aRover facing.
	! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:51:14'!
test12fowardOnEastGoRight
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: East.
	aRover interpretPackage: 'f'.
	self assert: 4@4 equals: aRover position.
	self assert: East equals: aRover facing.
	! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 16:51:37'!
test13fowardOnWestGoLeft
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: West.
	aRover interpretPackage: 'f'.
	self assert: 2@4 equals: aRover position.
	self assert: West equals: aRover facing.
	! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 17:09:45'!
test14fowardfowardOnNorthGoesUpTwice
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: North.
	aRover interpretPackage: 'ff'.
	self assert: 3@6 equals: aRover position.
	self assert: North equals: aRover facing.
	! !

!MarsTest methodsFor: 'testing' stamp: 'JRC 5/15/2021 17:08:59'!
test15ShouldStopAfterErrorInPackage
 	|aRover|
	aRover := MarsRover startingAt: (3@4) facing: North.
	aRover interpretPackage: 'fxf'.
	self assert: 3@5 equals: aRover position.
	self assert: North equals: aRover facing.
	! !


!classDefinition: #MarsDirection category: 'Mars-Rover-Ejercicio'!
Object subclass: #MarsDirection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars-Rover-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsDirection class' category: 'Mars-Rover-Ejercicio'!
MarsDirection class
	instanceVariableNames: ''!

!MarsDirection class methodsFor: 'vector' stamp: 'JRC 5/15/2021 17:15:43'!
left
	self subclassResponsibility ! !

!MarsDirection class methodsFor: 'vector' stamp: 'JRC 5/15/2021 17:15:46'!
right
	self subclassResponsibility ! !

!MarsDirection class methodsFor: 'vector' stamp: 'JRC 5/15/2021 17:15:39'!
vector
	self subclassResponsibility ! !



!classDefinition: #East category: 'Mars-Rover-Ejercicio'!
MarsDirection subclass: #East
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars-Rover-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'East class' category: 'Mars-Rover-Ejercicio'!
East class
	instanceVariableNames: ''!

!East class methodsFor: 'vector' stamp: 'JRC 5/15/2021 16:40:50'!
vector
	^1@0! !


!East class methodsFor: 'rotation' stamp: 'JRC 5/15/2021 16:19:59'!
left
	^North.! !

!East class methodsFor: 'rotation' stamp: 'JRC 5/15/2021 16:24:20'!
right
	^South.! !


!classDefinition: #North category: 'Mars-Rover-Ejercicio'!
MarsDirection subclass: #North
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars-Rover-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'North class' category: 'Mars-Rover-Ejercicio'!
North class
	instanceVariableNames: ''!

!North class methodsFor: 'rotation' stamp: 'JRC 5/15/2021 16:20:26'!
left
	^West! !

!North class methodsFor: 'rotation' stamp: 'JRC 5/15/2021 16:20:36'!
right
	^East! !


!North class methodsFor: 'vector' stamp: 'JRC 5/15/2021 16:41:12'!
vector
	^0@1! !


!classDefinition: #South category: 'Mars-Rover-Ejercicio'!
MarsDirection subclass: #South
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars-Rover-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'South class' category: 'Mars-Rover-Ejercicio'!
South class
	instanceVariableNames: ''!

!South class methodsFor: 'rotation' stamp: 'JRC 5/15/2021 16:23:18'!
left
	^East! !

!South class methodsFor: 'rotation' stamp: 'JRC 5/15/2021 16:24:38'!
right
	^West! !


!South class methodsFor: 'vector' stamp: 'JRC 5/15/2021 16:41:23'!
vector
	^0@-1! !


!classDefinition: #West category: 'Mars-Rover-Ejercicio'!
MarsDirection subclass: #West
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars-Rover-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'West class' category: 'Mars-Rover-Ejercicio'!
West class
	instanceVariableNames: ''!

!West class methodsFor: 'rotation' stamp: 'JRC 5/15/2021 16:25:31'!
left
	^South! !

!West class methodsFor: 'rotation' stamp: 'JRC 5/15/2021 16:25:42'!
right
	^North! !


!West class methodsFor: 'vector' stamp: 'JRC 5/15/2021 16:41:33'!
vector
	^-1@0! !


!classDefinition: #MarsRover category: 'Mars-Rover-Ejercicio'!
Object subclass: #MarsRover
	instanceVariableNames: 'position direction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars-Rover-Ejercicio'!

!MarsRover methodsFor: 'initialization' stamp: 'JRC 5/15/2021 15:19:47'!
initializeStartingAt: aPoint facing: aDirection 
	position := aPoint.
	direction := aDirection.! !


!MarsRover methodsFor: 'actions' stamp: 'JRC 5/15/2021 17:12:42'!
interpretPackage: aString 
aString do: [:aCharacter | 
	( #($f $b $r $l) includes: aCharacter ) ifFalse: [^self.].
	(aCharacter = $f) ifTrue:[
		position := position + direction vector.
		 ].
	(aCharacter = $b) ifTrue:[ 
		position := position - direction vector.
		].
	(aCharacter = $l) ifTrue:[ 
		direction := direction left.	
		].
	(aCharacter = $r) ifTrue:[ 
		direction := direction right.
		].
	].
! !


!MarsRover methodsFor: 'properties' stamp: 'JRC 5/15/2021 15:20:33'!
facing
	^direction! !

!MarsRover methodsFor: 'properties' stamp: 'JRC 5/15/2021 15:19:47'!
position
	^position! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'Mars-Rover-Ejercicio'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'instance creation' stamp: 'JRC 5/15/2021 15:14:26'!
startingAt: aPoint facing: aDirection
	^self new initializeStartingAt: aPoint facing: aDirection! !
