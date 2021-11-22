!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'jul 4/13/2021 17:18:49'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds


	self testCustomerBookWithInitialization: 
			[:customerBook | customerBook] 
		BlockToTime: 
			[:customerBook | customerBook addCustomerNamed: 'John Lennon'] 
		ExpectedCondition: 
			[:executionTime | executionTime < (50 * millisecond)]! !

!CustomerBookTest methodsFor: 'testing' stamp: 'jul 4/13/2021 17:18:49'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	|paulMcCartney| 
	paulMcCartney := 'Paul McCartney'.
	
	self testCustomerBookWithInitialization: 
			[:customerBook | customerBook addCustomerNamed: paulMcCartney.] 
		BlockToTime: 
			[:customerBook | customerBook removeCustomerNamed: paulMcCartney.] 
		ExpectedCondition: 
			[:executionTime | executionTime < (100 * millisecond)]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'jul 4/13/2021 17:48:24'!
test03CanNotAddACustomerWithEmptyName 
		
self testCustomerBookCannotDoTo: [:customerBook|customerBook] 
	WhatCannotDo: 
		[:customerBook| customerBook addCustomerNamed: ''.
		self fail ]
	 withError: 
		Error
	 withResponse: 
		[ :anError :customerBook | 
		self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
		self assert: customerBook isEmpty ] 
		
		! !

!CustomerBookTest methodsFor: 'testing' stamp: 'jul 4/13/2021 17:48:36'!
test04CanNotRemoveAnInvalidCustomer
	
	| johnLennon |
	johnLennon := 'John Lennon'.

self testCustomerBookCannotDoTo:
	 	[:customerBook| customerBook addCustomerNamed: johnLennon.] 
	WhatCannotDo: 
		[:customerBook| customerBook removeCustomerNamed: 'Paul McCartney'.
		self fail ]
	 withError: 
		NotFound 
	 withResponse: 
		[ :anError :customerBook | 
		self assert: customerBook numberOfCustomers = 1.
		self assert: (customerBook includesCustomerNamed: johnLennon) ] 
		
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'jul 4/15/2021 14:23:40'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

    | paulMcCartney|

    paulMcCartney := 'Paul McCartney'.
    self TestCustomerBookWithInitialization:[:customerBook | customerBook addCustomerNamed: paulMcCartney.
                                                customerBook suspendCustomerNamed: paulMcCartney.]
                    expectedToPass:[:customerBook | {
                                                0 = (customerBook numberOfActiveCustomers).
                                                1 = (customerBook numberOfSuspendedCustomers).
                                                1 = (customerBook numberOfCustomers).
                                                }]
                    expectedToFail:[:customerBook | {}]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'jul 4/15/2021 14:27:32'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

    | paulMcCartney |

    paulMcCartney := 'Paul McCartney'.

    self TestCustomerBookWithInitialization: [:customerBook | 
                        customerBook addCustomerNamed: paulMcCartney.
                        customerBook suspendCustomerNamed: paulMcCartney.
                        customerBook removeCustomerNamed: paulMcCartney.] 
            expectedToPass: [:customerBook | {
                                0 = customerBook numberOfActiveCustomers.
                                0 = customerBook numberOfSuspendedCustomers.
                                0 = customerBook numberOfCustomers.}] 
            expectedToFail: [:customerBook | {customerBook includesCustomerNamed: paulMcCartney}]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'jul 4/13/2021 17:25:11'!
test07CanNotSuspendAnInvalidCustomer

	| johnLennon |
	johnLennon := 'John Lennon'.

self testCustomerBookCannotDoTo:
	 	[:customerBook| customerBook addCustomerNamed: johnLennon.] 
	WhatCannotDo: 
		[:customerBook| customerBook suspendCustomerNamed: 'George Harrison'.
		self fail]
	 withError: CantSuspend 
	 withResponse: 
		[ :anError :customerBook | 
		self assert: customerBook numberOfCustomers = 1.
		self assert: (customerBook includesCustomerNamed: johnLennon) ] 
		! !

!CustomerBookTest methodsFor: 'testing' stamp: 'jul 4/13/2021 17:28:21'!
test08CanNotSuspendAnAlreadySuspendedCustomer

	| johnLennon |
	johnLennon := 'John Lennon'.

self testCustomerBookCannotDoTo:
	 	[:customerBook| customerBook addCustomerNamed: johnLennon.
		customerBook suspendCustomerNamed: johnLennon.] 
	WhatCannotDo: 
		[:customerBook| customerBook suspendCustomerNamed: johnLennon.
		self fail ]
	 withError: CantSuspend 
	 withResponse: 
		[ :anError :customerBook | 
		self assert: customerBook numberOfCustomers = 1.
		self assert: (customerBook includesCustomerNamed: johnLennon) ] 

! !


!CustomerBookTest methodsFor: 'private' stamp: 'jul 4/15/2021 14:23:07'!
TestCustomerBookWithInitialization: aInitializationBlock expectedToPass: aBlockWithAnArrayOfConditionsToPass expectedToFail:  aBlockWithAnArrayOfConditionsToFail

    | customerBook |

    customerBook := CustomerBook new.
    aInitializationBlock  value: customerBook.

    (aBlockWithAnArrayOfConditionsToPass value:customerBook) do: [:condition |self assert: condition].
    (aBlockWithAnArrayOfConditionsToFail value:customerBook ) do: [:condition |self deny: condition].! !

!CustomerBookTest methodsFor: 'private' stamp: 'jul 4/13/2021 17:18:14'!
testCustomerBookCannotDoTo: aInitializationBlock WhatCannotDo: aBlockwithError withError: anErrorName withResponse: anErrorResponse 

	
	| customerBook |
			
	customerBook := CustomerBook new.
	aInitializationBlock value: customerBook.
	
	[aBlockwithError value: customerBook ]
		on: anErrorName
		do: [:anError | anErrorResponse value:anError value: customerBook]! !

!CustomerBookTest methodsFor: 'private' stamp: 'jul 4/13/2021 17:18:49'!
testCustomerBookWithInitialization: aInitializationBlock BlockToTime: aBlockToTime ExpectedCondition: aBlockWithCondition

| customerBook millisecondsBeforeRunning millisecondsAfterRunning |
	
	customerBook := CustomerBook new.
	aInitializationBlock value: customerBook .
	  
	millisecondsBeforeRunning := Time millisecondClockValue * millisecond.
	aBlockToTime value: customerBook.
	millisecondsAfterRunning := Time millisecondClockValue * millisecond.
	
	self assert: (aBlockWithCondition value: (millisecondsAfterRunning-millisecondsBeforeRunning)).

	
! !

!CustomerBookTest methodsFor: 'private' stamp: 'jul 4/13/2021 17:47:03'!
testCustomerBookWithInitialization: aInitializationBlock ExpectedCondition: aBlockWithCondition

| customerBook |
	
	customerBook := CustomerBook new.
	aInitializationBlock value: customerBook .
	  
	
	aBlockWithCondition value: customerBook.

	
! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 9/17/2020 07:23:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'private' stamp: 'jul 4/15/2021 15:07:10'!
removeUserNamed: aName  fromCollection: aCollection
 
	1 to: aCollection size do: 
	[ :index |
		aName = (aCollection at: index)
			ifTrue: [
				aCollection removeAt: index.
				^ true
			] 
	].
	^false! !


!CustomerBook methodsFor: 'customer management' stamp: 'jul 4/15/2021 15:16:17'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(self includesCustomerNamed: aName) ifTrue: [ self signalCustomerAlreadyExists ].
	
	active add: aName 

! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfCustomers
	
	^active size + suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'jul 4/15/2021 15:17:46'!
removeCustomerNamed: aName 

	| wasRemovedFromActive wasRemovedFromSuspended  |
	
	wasRemovedFromActive := self removeUserNamed: aName  fromCollection: active.
	wasRemovedFromSuspended := self removeUserNamed: aName  fromCollection: suspended.
	
	(wasRemovedFromActive or: wasRemovedFromSuspended ) ifTrue: [^aName].
	
	^NotFound signal.
! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
suspendCustomerNamed: aName 
	
	(active includes: aName) ifFalse: [^CantSuspend signal].
	
	active remove: aName.
	
	suspended add: aName
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/12/2021 16:39:13'!
customerAlreadyExistsErrorMessage

	^'customer already exists!!!!!!'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/12/2021 16:39:09'!
customerCanNotBeEmptyErrorMessage

	^'customer name cannot be empty!!!!!!'! !
