!classDefinition: #MarsRoverListenerTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverListenerTest
	instanceVariableNames: 'testLog testWindow'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 14:59:35'!
setUp

	testLog := MarsRoverLog createNew.
	testWindow := MarsRoverWindow createNew.! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 14:57:42'!
test01MarsRoverLogForARoverThatProcessedNothingIsEmpty
	
	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {testLog} 
			withPositionOnlyListeners: {}  
			withRotationOnlyListeners: {}  
			processing: ''  
			asserting: [self assert: 0 equals: testLog size]. ! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:00:37'!
test02MarsRoverLogForARoverThatMovedForwardFacingNorthDisplaysCorrectly
	
	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {testLog} 
			withPositionOnlyListeners: {}  
			withRotationOnlyListeners: {}  
			processing: 'f'  
			asserting: [self assert: 1 equals: testLog size.
					self assert: '1@3' equals: testLog first.].
	! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:01:16'!
test03MarsRoverLogForARoverThatMovedBackwardsFacingNorthDisplaysCorrectly
	
	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {testLog} 
			withPositionOnlyListeners: {}  
			withRotationOnlyListeners: {}  
			processing: 'b'  
			asserting: [self assert: 1 equals: testLog size.
					self assert: '1@1' equals: testLog first.].! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:01:51'!
test04MarsRoverLogForARoverThatRotatedRightWhileFacingNorthDisplaysCorrectly
	
	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {testLog} 
			withPositionOnlyListeners: {}  
			withRotationOnlyListeners: {}  
			processing: 'r'  
			asserting: [self assert: 1 equals: testLog size.
					self assert: 'East' equals: testLog first.].! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:02:53'!
test05MarsRoverLogForRoverThatLRotatedLeftTwiceWhileFacingNorthDisplaysCorrectly
	
	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {testLog} 
			withPositionOnlyListeners: {}  
			withRotationOnlyListeners: {}  
			processing: 'll'  
			asserting: [self assert: 2 equals: testLog size.
					self assert: 'West' equals: testLog first.
					self assert: 'South' equals: testLog second.].! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:04:02'!
test06MarsRoverWindowForARoverThatProcessedDisplaysEmptyStrings
	
	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {testWindow} 
			withPositionOnlyListeners: {}  
			withRotationOnlyListeners: {}  
			processing: ''  
			asserting: [self assert: '' equals: testWindow displayDirectionTextModel.
					self assert: '' equals: testWindow displayPositionTextModel.].! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:10:21'!
test07MarsRoverWindowForARoverThatMovedForwardWhileFacingNorthOnlyRegistersPosition

	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {testWindow} 
			withPositionOnlyListeners: {} 
			withRotationOnlyListeners: {}
			processing: 'f'  
			asserting: [self assert: '' equals: testWindow displayDirectionTextModel.
					self assert: '1@3' equals: testWindow displayPositionTextModel.].! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:11:15'!
test08MarsRoverWindowForARoverThatMovedBackwardWhileFacingNorthOnlyRegistersPosition
	
	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {testWindow} 
			withPositionOnlyListeners: {} 
			withRotationOnlyListeners: {}
			processing: 'b'  
			asserting: [self assert: '' equals: testWindow displayDirectionTextModel.
					self assert: '1@1' equals: testWindow displayPositionTextModel.].
! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:12:20'!
test09MarsRoverWindowForARoverThatRotatedToTheRightWhileFacingNorthOnlyRegistersRotation

	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {testWindow} 
			withPositionOnlyListeners: {} 
			withRotationOnlyListeners: {}
			processing: 'r'  
			asserting: [self assert: 'East' equals: testWindow displayDirectionTextModel.
					self assert: '' equals: testWindow displayPositionTextModel.].
	! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:14:55'!
test10MarsRoverLogThatMovedSeveralTimesRegistersPositionCorrectly
	
	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {testLog} 
			withPositionOnlyListeners: {} 
			withRotationOnlyListeners: {}
			processing: 'fffff'  
			asserting: [self assert: 5 equals: testLog size.
					self assert: '1@5' equals: (testLog at: 3).].! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:18:31'!
test11MarsRoverLogSetToOnlyRegisterPositionDoesNotRegisterRotation
	
	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {} 
			withPositionOnlyListeners: {testLog} 
			withRotationOnlyListeners: {}
			processing: 'frrrrrrrrf'  
			asserting: [self assert: 2 equals: testLog size.
					self assert: '1@3' equals: (testLog first).
					self assert: '1@4' equals: (testLog second).].! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 15:19:53'!
test12MarsRoverLogSetToOnlyRegisterRotationDoesNotRegisterPosition
	
	self testMarsRoverAt: 1@2 heading: #North 
			withListeners: {} 
			withPositionOnlyListeners: {} 
			withRotationOnlyListeners: {testLog}
			processing: 'rffffffbbbbbr'  
			asserting: [self assert: 2 equals: testLog size.
					self assert: 'East' equals: (testLog first).
					self assert: 'South' equals: (testLog second).].! !

!MarsRoverListenerTest methodsFor: 'testing' stamp: 'G.L.S 6/7/2021 14:52:29'!
testMarsRoverAt: aPoint heading: aCardinalDirection withListeners: aListenerCollection withPositionOnlyListeners: aPositionOnlyListenerCollection
withRotationOnlyListeners: aRotationOnlyListenerCollection processing: aStringToProcess asserting: aBlockOfAssertions

	| marsRover |
	
	marsRover := MarsRover at: aPoint heading: aCardinalDirection.
	
	aListenerCollection do: [:aListener | marsRover addListener: aListener].
	aPositionOnlyListenerCollection do: [:aPositionListener | marsRover addPositionListener: aPositionListener].
	aRotationOnlyListenerCollection do: [:aRotationListener | marsRover addRotationListener: aRotationListener].
	
	marsRover process: aStringToProcess.
	
	aBlockOfAssertions value.! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:23:26'!
test01

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #North.
	
	marsRover process: ''.
	
	self assert: (marsRover isAt: 1@2 heading: #North)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:23:31'!
test02

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #North.
	
	marsRover process: 'f'.
	
	self assert: (marsRover isAt: 1@3 heading: #North)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:23:34'!
test03

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #North.
	
	marsRover process: 'b'.
	
	self assert: (marsRover isAt: 1@1 heading: #North)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:23:38'!
test04

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #North.
	
	marsRover process: 'r'.
	
	self assert: (marsRover isAt: 1@2 heading: #East)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:23:45'!
test05

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #North.
	
	marsRover process: 'l'.
	
	self assert: (marsRover isAt: 1@2 heading: #West)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:23:50'!
test06

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #North.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: #North) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:23:54'!
test07

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #North.
	
	marsRover process: 'ff'.
	
	self assert: (marsRover isAt: 1@4 heading: #North)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:23:59'!
test08

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #East.
	
	marsRover process: 'f'.
	
	self assert: (marsRover isAt: 2@2 heading: #East)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:24:06'!
test09

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #East.
	
	marsRover process: 'b'.
	
	self assert: (marsRover isAt: 0@2 heading: #East)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:24:12'!
test10

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #East.
	
	marsRover process: 'r'.
	
	self assert: (marsRover isAt: 1@2 heading: #South)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:24:20'!
test11

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #East.
	
	marsRover process: 'l'.
	
	self assert: (marsRover isAt: 1@2 heading: #North)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:24:25'!
test12

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #South.
	
	marsRover process: 'ffbr'.
	
	self assert: (marsRover isAt: 1@1 heading: #West)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:24:29'!
test13

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #South.
	
	marsRover process: 'l'.
	
	self assert: (marsRover isAt: 1@2 heading: #East)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:24:33'!
test14

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #West.
	
	marsRover process: 'ffbr'.
	
	self assert: (marsRover isAt: 0@2 heading: #North)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/1/2018 14:24:37'!
test15

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: #West.
	
	marsRover process: 'l'.
	
	self assert: (marsRover isAt: 1@2 heading: #South)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 7/2/2018 16:27:43'!
test16

	self 
		should: [MarsRover at: 1@2 heading: #X ]
		raise: Error
		withExceptionDo: [:anError |
			self assert: MarsRover invalidCardinalPointErrorDescription equals: anError messageText ]! !


!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head positionListeners rotationListeners'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'G.L.S 6/7/2021 14:40:25'!
initializeAt: aPosition heading: aHeading

	position := aPosition.
	head := aHeading.
	positionListeners := OrderedCollection new.
	rotationListeners := OrderedCollection new.! !


!MarsRover methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 20:51:04'!
headEast
	
	head := MarsRoverHeadingEast new.! !

!MarsRover methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 20:50:57'!
headNorth
	
	head := MarsRoverHeadingNorth new.! !

!MarsRover methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 20:50:51'!
headSouth
	
	head := MarsRoverHeadingSouth new.! !

!MarsRover methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 20:50:42'!
headWest
	
	head := MarsRoverHeadingWest new.! !

!MarsRover methodsFor: 'heading' stamp: 'G.L.S 6/7/2021 14:40:02'!
reportRotation

	rotationListeners do:[:aListener | aListener registerRotation: head].! !

!MarsRover methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 20:50:24'!
rotateLeft
	
	head rotateLeft: self.
	self reportRotation.! !

!MarsRover methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 20:50:32'!
rotateRight
	
	head rotateRight: self.
	self reportRotation.! !


!MarsRover methodsFor: 'testing' stamp: 'HAW 8/22/2019 12:00:30'!
isAt: aPosition heading: aCardinalPoint

	^position = aPosition and: [ head isHeading: aCardinalPoint ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !


!MarsRover methodsFor: 'moving' stamp: 'G.L.S 6/7/2021 14:40:13'!
changePosition: aPosition
	
	position := aPosition.
	positionListeners do: [:aListener | aListener registerPosition: position].! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:05:20'!
moveBackward
	
	head moveBackward: self! !

!MarsRover methodsFor: 'moving' stamp: 'G.L.S 6/5/2021 19:55:18'!
moveEast
	
	self changePosition: position + (1@0).! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:05:55'!
moveForward
	
	head moveForward: self! !

!MarsRover methodsFor: 'moving' stamp: 'G.L.S 6/5/2021 19:55:01'!
moveNorth

	self changePosition: position + (0@1).! !

!MarsRover methodsFor: 'moving' stamp: 'G.L.S 6/5/2021 19:54:54'!
moveSouth
	
	self changePosition: position + (0@-1).! !

!MarsRover methodsFor: 'moving' stamp: 'G.L.S 6/5/2021 19:55:33'!
moveWest
	
	self changePosition: position + (-1@0).! !


!MarsRover methodsFor: 'command processing' stamp: 'HAW 6/30/2018 19:48:26'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 8/22/2019 12:08:50'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !


!MarsRover methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/7/2021 14:41:06'!
addListener: aMarsRoverListener 
	self addPositionListener: aMarsRoverListener.
	self addRotationListener: aMarsRoverListener.! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/7/2021 14:37:55'!
addPositionListener: aMarsRoverLog 
	positionListeners add: aMarsRoverLog! !

!MarsRover methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/7/2021 14:37:23'!
addRotationListener: aMarsRoverLog 
	rotationListeners add: aMarsRoverLog ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 8/22/2019 12:01:48'!
at: aPosition heading: aCardinalPoint
	
	^self new initializeAt: aPosition heading: (MarsRoverHeading heading: aCardinalPoint)! !

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 7/2/2018 16:26:14'!
invalidCardinalPointErrorDescription
	
	^'Invalid cardinal point'! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 21:04:48'!
directionAsString
	self subclassResponsibility.! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 21:07:12'!
directionAsStringForListener: aMarsRoverListener
	self subclassResponsibility.! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 8/22/2019 12:06:17'!
rotateLeft: aMarsRover

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 8/22/2019 12:08:23'!
rotateRight: aMarsRover

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 7/2/2018 19:07:42'!
isHeading: aCardinalPoint

	^self class isFor: aCardinalPoint! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:05:20'!
moveBackward: aMarsRover

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:05:54'!
moveForward: aMarsRover

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'cardinal point' stamp: 'HAW 7/2/2018 19:07:01'!
cardinalPoint

	self subclassResponsibility ! !


!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 8/22/2019 12:02:00'!
heading: aCardinalPoint

	^self subclasses 
		detect: [ :aMarsRoverPositionClass | aMarsRoverPositionClass isFor: aCardinalPoint ]
		ifFound: [ :aMarsRoverPositionClass | aMarsRoverPositionClass new ]
		ifNone: [ self error: MarsRover invalidCardinalPointErrorDescription ]! !


!MarsRoverHeading class methodsFor: 'testing' stamp: 'HAW 7/2/2018 17:01:33'!
isFor: aCardinalPoint

	^self cardinalPoint = aCardinalPoint ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:09:19'!
moveBackward: aMarsRover
	
	^aMarsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:09:28'!
moveForward: aMarsRover
	
	^aMarsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 21:07:53'!
directionAsStringForListener: aMarsRoverListener
	
	^aMarsRoverListener directionStringForEast.! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 8/22/2019 12:09:42'!
rotateLeft: aMarsRover
	
	^aMarsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 8/22/2019 12:09:54'!
rotateRight: aMarsRover
	
	^aMarsRover headSouth! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeadingEast class' category: 'MarsRover-WithHeading'!
MarsRoverHeadingEast class
	instanceVariableNames: ''!

!MarsRoverHeadingEast class methodsFor: 'as yet unclassified' stamp: 'HAW 7/2/2018 17:01:53'!
cardinalPoint

	^#East! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:10:12'!
moveBackward: aMarsRover
	
	^aMarsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:10:23'!
moveForward: aMarsRover
	
	^aMarsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 21:08:12'!
directionAsStringForListener: aMarsRoverListener
	
	^aMarsRoverListener directionStringForNorth.! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 8/22/2019 12:10:40'!
rotateLeft: aMarsRover
	
	^aMarsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 8/22/2019 12:10:51'!
rotateRight: aMarsRover
	
	^aMarsRover headEast! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeadingNorth class' category: 'MarsRover-WithHeading'!
MarsRoverHeadingNorth class
	instanceVariableNames: ''!

!MarsRoverHeadingNorth class methodsFor: 'as yet unclassified' stamp: 'HAW 7/2/2018 17:03:11'!
cardinalPoint

	^#North! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:11:15'!
moveBackward: aMarsRover
	
	^aMarsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:11:25'!
moveForward: aMarsRover
	
	^aMarsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 21:08:32'!
directionAsStringForListener: aMarsRoverListener
	
	^aMarsRoverListener directionStringForSouth.! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 8/22/2019 12:11:55'!
rotateLeft: aMarsRover
	
	^aMarsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 8/22/2019 12:11:50'!
rotateRight: aMarsRover
	
	^aMarsRover headWest! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeadingSouth class' category: 'MarsRover-WithHeading'!
MarsRoverHeadingSouth class
	instanceVariableNames: ''!

!MarsRoverHeadingSouth class methodsFor: 'as yet unclassified' stamp: 'HAW 7/2/2018 17:03:17'!
cardinalPoint

	^#South! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:12:07'!
moveBackward: aMarsRover

	^aMarsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:12:15'!
moveForward: aMarsRover
	
	^aMarsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'G.L.S 6/5/2021 21:08:48'!
directionAsStringForListener: aMarsRoverListener
	
	^aMarsRoverListener directionStringForWest.! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 8/22/2019 12:12:26'!
rotateLeft: aMarsRover
	
	^aMarsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 8/22/2019 12:12:41'!
rotateRight: aMarsRover
	
	^aMarsRover headNorth! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeadingWest class' category: 'MarsRover-WithHeading'!
MarsRoverHeadingWest class
	instanceVariableNames: ''!

!MarsRoverHeadingWest class methodsFor: 'as yet unclassified' stamp: 'HAW 7/2/2018 17:03:23'!
cardinalPoint

	^#West! !


!classDefinition: #MarsRoverObserver category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverObserver
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverObserver methodsFor: 'events' stamp: 'G.L.S 6/5/2021 20:45:07'!
registerPosition: aPosition 
	self subclassResponsibility.! !

!MarsRoverObserver methodsFor: 'events' stamp: 'G.L.S 6/5/2021 20:45:43'!
registerRotation: aMarsRoverHead
	self subclassResponsibility.! !


!MarsRoverObserver methodsFor: 'private' stamp: 'G.L.S 6/5/2021 21:11:05'!
directionStringForEast
	^'East'! !

!MarsRoverObserver methodsFor: 'private' stamp: 'G.L.S 6/5/2021 21:10:50'!
directionStringForNorth
	^'North'! !

!MarsRoverObserver methodsFor: 'private' stamp: 'G.L.S 6/5/2021 21:10:57'!
directionStringForSouth
	^'South'! !

!MarsRoverObserver methodsFor: 'private' stamp: 'G.L.S 6/5/2021 21:10:42'!
directionStringForWest
	^'West'! !


!classDefinition: #MarsRoverLog category: 'MarsRover-WithHeading'!
MarsRoverObserver subclass: #MarsRoverLog
	instanceVariableNames: 'log'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLog methodsFor: 'initialization' stamp: 'G.L.S 6/5/2021 19:07:13'!
initializeLog
	log := OrderedCollection new.! !


!MarsRoverLog methodsFor: 'events' stamp: 'G.L.S 6/5/2021 19:12:54'!
registerPosition: aPosition 
	log add: aPosition asString.! !

!MarsRoverLog methodsFor: 'events' stamp: 'G.L.S 6/5/2021 21:06:38'!
registerRotation: aMarsRoverHead
	log add: (aMarsRoverHead directionAsStringForListener: self).! !


!MarsRoverLog methodsFor: 'operations' stamp: 'G.L.S 6/5/2021 21:19:30'!
at: index

	^log at: index.! !

!MarsRoverLog methodsFor: 'operations' stamp: 'G.L.S 6/5/2021 19:13:45'!
first
	^log first.! !

!MarsRoverLog methodsFor: 'operations' stamp: 'G.L.S 6/5/2021 19:28:59'!
second
	^log second.! !

!MarsRoverLog methodsFor: 'operations' stamp: 'G.L.S 6/5/2021 19:07:45'!
size
	^log size.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverLog class' category: 'MarsRover-WithHeading'!
MarsRoverLog class
	instanceVariableNames: ''!

!MarsRoverLog class methodsFor: 'instance creation' stamp: 'G.L.S 6/5/2021 18:59:15'!
createNew

	^self new initializeLog! !


!classDefinition: #MarsRoverWindow category: 'MarsRover-WithHeading'!
MarsRoverObserver subclass: #MarsRoverWindow
	instanceVariableNames: 'position direction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverWindow methodsFor: 'initialization' stamp: 'G.L.S 6/5/2021 19:47:44'!
initializeWindow
	position := nil.
	direction := nil.! !


!MarsRoverWindow methodsFor: 'display' stamp: 'G.L.S 6/5/2021 21:06:59'!
displayDirectionTextModel
	direction ifNil: [^''].
	^direction directionAsStringForListener: self.! !

!MarsRoverWindow methodsFor: 'display' stamp: 'G.L.S 6/5/2021 19:51:36'!
displayPositionTextModel
	position ifNil: [^''].
	^position asString.! !


!MarsRoverWindow methodsFor: 'events' stamp: 'G.L.S 6/5/2021 19:48:15'!
registerPosition: aPosition 
	^position := aPosition.! !

!MarsRoverWindow methodsFor: 'events' stamp: 'G.L.S 6/5/2021 20:48:44'!
registerRotation: aMarsRoverHead 
	direction  := aMarsRoverHead.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverWindow class' category: 'MarsRover-WithHeading'!
MarsRoverWindow class
	instanceVariableNames: ''!

!MarsRoverWindow class methodsFor: 'instance creation' stamp: 'G.L.S 6/5/2021 19:33:41'!
createNew
	^self new initializeWindow.! !
