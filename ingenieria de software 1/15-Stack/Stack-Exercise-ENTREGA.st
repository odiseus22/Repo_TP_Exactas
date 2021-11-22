!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'jul 4/26/2021 02:38:00'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 4/22/2021 17:25:26'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'firstObject'.
	secondPushedObject := 'secondObject'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'GS 4/28/2021 17:34:01'!
test01FindInEmptyStackShouldReturnAnEmptyCollection
	
	self testFind: 'ABC' InStackWith: {} expectToFind: {}.
! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'GS 4/28/2021 17:35:22'!
test02FindASentenceThatIsNotInTheStack
	
	self testFind: 'ABC' InStackWith: {'abc'. 'Abc'. 'BCA'. 'nadaQueVer'.} expectToFind: {}.
! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'GS 4/28/2021 17:36:55'!
test03FindASentenceThatIsOnceInTheStack
	
	self testFind: 'ABC' InStackWith: {'abc'. 'Abc'. 'BCA'. 'nadaQueVer'. 'ABCnadaQueVer'.}  expectToFind: {'ABCnadaQueVer'.}.
! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'GS 4/28/2021 17:39:12'!
test04FindASentenceThatIsManyTimesInTheStack
	
	self testFind: 'ABC' InStackWith: {'abc'. 'Abc'. 'ABCBCA'. 'nadaQueVer'. 'ABCnadaQueVer'.} expectToFind: {'ABCnadaQueVer'. 'ABCBCA'.}.
! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'GS 4/28/2021 17:40:46'!
test05DontFindASentenceWithThePrefixAsSuffix
	
	self testFind: 'ABC' InStackWith: {'abcABC'. 'AbcaABC'. 'BCABC'. 'nadaQueVerABC'.} expectToFind: {}.
! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'GS 4/28/2021 17:42:42'!
test06DontFindASentenceWithThePrefixAsInfix
	
	self testFind: 'ABC' InStackWith: {'abABCc'. 'AABCbca'. 'BABCC'. 'nadaABCQueVer'.} expectToFind: {}.
! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'GS 4/28/2021 18:23:19'!
test07StackDoesNotChangeSizeAfterNotFinding

	self testFind: 'ABC' WithoutChangingTheSizeOfAStackWith: {'abcABC'. 'AbcaABC'. 'BCABC'. 'nadaQueVerABC'.}.
! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'GS 4/28/2021 17:59:48'!
test08StackDoesNotChangeContentAfterNotFinding

	self testFind: 'ABC'  WithoutChangingAStackWith: {'abcABC'. 'AbcaABC'. 'BCABC'. 'nadaQueVerABC'.}.
! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'GS 4/28/2021 18:24:08'!
test09StackDoesNotChangeSizeAfterFinding
	
	self testFind: 'ABC' WithoutChangingTheSizeOfAStackWith: {'abcABC'. 'ABCbcaABC'. 'BCABC'. 'ABCnadaQueVerABC'.}.

! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'GS 4/28/2021 18:00:50'!
test10StackDoesNotChangeAfterFinding

	self testFind: 'ABC'  WithoutChangingAStackWith: {'abcABC'. 'ABCbcaABC'. 'BCABC'. 'ABCnadaQueVerABC'.}.

! !


!SentenceFinderByPrefixTest methodsFor: 'private' stamp: 'GS 4/28/2021 18:20:26'!
testFind: aPrefix InStackWith: anArrayOfStringsToStack expectToFind: anArrayOfExpectedStrings

	|aStack aSentenceFinder ExpectedOrderedCollection|
	aStack := OOStack new.
	ExpectedOrderedCollection := OrderedCollection new.
	
	anArrayOfStringsToStack do: [:aString | aStack push: aString].
	
	anArrayOfExpectedStrings do: [:aString | ExpectedOrderedCollection  add: aString].
	
	aSentenceFinder := SentenceFinderByPrefix new initializeWith: aStack.
	
	self assert: (aSentenceFinder find: aPrefix) equals: ExpectedOrderedCollection.! !

!SentenceFinderByPrefixTest methodsFor: 'private' stamp: 'GS 4/28/2021 17:58:16'!
testFind: aPrefix WithoutChangingAStackWith: anArrayOfStrings

	|aStack aSentenceFinder ExpectedStack |
	aStack := OOStack new.
	ExpectedStack  := OOStack new.
	aSentenceFinder := SentenceFinderByPrefix new initializeWith: aStack.
	
	anArrayOfStrings do: [:string | aStack push: string.
							ExpectedStack push: string. ].
	
	aSentenceFinder find: aPrefix.
	
	[aStack isEmpty ] whileFalse: [
		self assert:  (aStack pop) equals: ExpectedStack pop.
	]! !

!SentenceFinderByPrefixTest methodsFor: 'private' stamp: 'GS 4/28/2021 18:21:15'!
testFind: aPrefix WithoutChangingTheSizeOfAStackWith: anArrayOfStrings

	|aStack aSentenceFinder  aStackSize|
	aStack := OOStack new.

	aSentenceFinder := SentenceFinderByPrefix new initializeWith: aStack.
	
	anArrayOfStrings do: [:string | aStack push: string].
	
	aStackSize := aStack size.
	
	aSentenceFinder find: aPrefix.

	self assert:  (aStack size ) equals: aStackSize.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefixTest class' category: 'Stack-Exercise'!
SentenceFinderByPrefixTest class
	instanceVariableNames: 'stackVacio stackPobaldo'!


!classDefinition: #OOStack category: 'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'size last'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'initialization' stamp: 'GS 4/26/2021 21:37:29'!
initialize
	size := 0.
	last := OOStackEmptyElement new.! !


!OOStack methodsFor: 'operation' stamp: 'GS 4/26/2021 21:29:12'!
isEmpty
	^last isEmpty.! !

!OOStack methodsFor: 'operation' stamp: 'GS 4/26/2021 21:52:07'!
pop
	|returnValue|
	
	returnValue := last value.
	size := size - 1.
	last := last previous.
	
	^returnValue.
	

	! !

!OOStack methodsFor: 'operation' stamp: 'GS 4/26/2021 21:37:04'!
push: anItemToPush
	size := size + 1.
	last := OOStackNonEmptyElement new initializeWith: anItemToPush withPreviousElement: last.
	
	! !

!OOStack methodsFor: 'operation' stamp: 'GS 4/26/2021 21:25:34'!
size
	^size.! !

!OOStack methodsFor: 'operation' stamp: 'GS 4/29/2021 15:40:07'!
top
	^last value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: 'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'NR 4/22/2021 17:22:41'!
stackEmptyErrorDescription
	
	^ 'Stack is empty!!!!!!'! !



!classDefinition: #OOStackEmptyElement category: 'Stack-Exercise'!
Object subclass: #OOStackEmptyElement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackEmptyElement methodsFor: 'operations' stamp: 'GS 4/26/2021 21:51:18'!
isEmpty
	^true.! !

!OOStackEmptyElement methodsFor: 'operations' stamp: 'GS 4/26/2021 21:49:01'!
previous
	self error: OOStack stackEmptyErrorDescription.! !

!OOStackEmptyElement methodsFor: 'operations' stamp: 'GS 4/26/2021 21:46:42'!
value
	self error: OOStack stackEmptyErrorDescription.! !


!classDefinition: #OOStackNonEmptyElement category: 'Stack-Exercise'!
Object subclass: #OOStackNonEmptyElement
	instanceVariableNames: 'value previousElement'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackNonEmptyElement methodsFor: 'initialization' stamp: 'GS 4/26/2021 21:32:32'!
initializeWith: aValue withPreviousElement: aOOStackElement
	value := aValue.
	previousElement := aOOStackElement.! !


!OOStackNonEmptyElement methodsFor: 'operations' stamp: 'GS 4/26/2021 21:51:26'!
isEmpty
	^false.! !

!OOStackNonEmptyElement methodsFor: 'operations' stamp: 'GS 4/26/2021 21:49:17'!
previous
	^previousElement ! !

!OOStackNonEmptyElement methodsFor: 'operations' stamp: 'GS 4/26/2021 21:45:41'!
value
	^value .! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: 'aStack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'initialization' stamp: 'GS 4/26/2021 20:56:04'!
initializeWith: aInitialCollection
	aStack  := aInitialCollection.
	! !


!SentenceFinderByPrefix methodsFor: 'operation' stamp: 'GS 4/29/2021 15:47:08'!
find: prefix
	|wordFound collectionWithFoundWords aCollectionCopy|
	
	collectionWithFoundWords := OrderedCollection new.
	aCollectionCopy := OrderedCollection new.

	[aStack isEmpty] whileFalse: [
						wordFound := aStack pop.
						aCollectionCopy addFirst: wordFound.
						(wordFound beginsWith: prefix) ifTrue: [collectionWithFoundWords add: wordFound ]
						].

	aCollectionCopy do: [:elem | aStack push: elem].
	
	^collectionWithFoundWords.
	
	
! !
