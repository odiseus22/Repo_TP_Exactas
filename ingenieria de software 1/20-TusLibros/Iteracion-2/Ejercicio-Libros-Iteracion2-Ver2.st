!classDefinition: #CartTest category: 'Ejercicio-Libros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'smalltalk80 designPatterns objectThinking emptyCatalog catalog1'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!CartTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:31:30'!
setUp

	smalltalk80 := '9780201113723'.
	designPatterns := '9780201184624'.
	objectThinking := '9780735619654'.
	
	emptyCatalog := Dictionary new.
	
	catalog1 := Dictionary new.
	catalog1 add: smalltalk80 -> 10.
	catalog1 add: designPatterns -> 100.
	catalog1 add: objectThinking -> 50.! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:26:27'!
test01CartThatWasJustCreatedIsEmpty

	| carrito |
	
	carrito := Cart createNewWithCatalog: emptyCatalog.
	
	self assert: carrito isEmpty.
	! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:26:53'!
test02CartWithAnItemIsNotEmpty

	| carrito |
	
	carrito := Cart createNewWithCatalog: catalog1.
	carrito add: smalltalk80.
	
	self deny: carrito isEmpty.
	! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:28:50'!
test03CartWithSeveralItemsAddedContainsTheRightItemsAndAmounts

	| carrito tuplaLibroCant |
	
	carrito := Cart createNewWithCatalog: catalog1.
		
	carrito add: smalltalk80 amount: 4.
	carrito add: designPatterns amount: 2.
	
	tuplaLibroCant := OrderedCollection new.
	tuplaLibroCant add: smalltalk80.
	tuplaLibroCant add: 4.
	
	self deny: carrito isEmpty.
	self assert: 2 equals: carrito size.
	self assert: tuplaLibroCant equals: carrito first.
	
	tuplaLibroCant := OrderedCollection new.
	tuplaLibroCant add: designPatterns .
	tuplaLibroCant add: 2.
	
	self assert: tuplaLibroCant equals: carrito second.! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:30:26'!
test04CartCannotAddItemsThatAreNotAllowed
		
	self testCartFailToAdd: smalltalk80 
		withAmount: 1
		whileAllowing: emptyCatalog 
		expectingErrorMessage: Cart errorBookNotInAllowedList.
	! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:30:36'!
test05CartCannotAddANonIntegerAmountOfAnItem
	
	self testCartFailToAdd: smalltalk80 
		withAmount: 1.5
		whileAllowing: catalog1  
		expectingErrorMessage: Cart errorAmountNotInteger.
	! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:30:40'!
test06CartCannotAddANegativeAmountOfAnItem
	
	self testCartFailToAdd: smalltalk80 
		withAmount: -1
		whileAllowing: catalog1  
		expectingErrorMessage: Cart errorAmountNegative.! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:30:46'!
test07CartCannotAddAZeroAmountOfAnItem
	
	self testCartFailToAdd: smalltalk80 
		withAmount: 0
		whileAllowing: catalog1  
		expectingErrorMessage: Cart errorAmountZero.
	! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:29:34'!
testCartFailToAdd: aBook withAmount: anAmount whileAllowing: aBookList expectingErrorMessage: anErrorMessage

	| carrito |
	
	carrito := Cart createNewWithCatalog: aBookList.
	
	self should: [
		carrito add: aBook amount: anAmount.
		]
		raise: Error  
		withExceptionDo: [
			:anError |
			self assert: anError messageText equals: anErrorMessage.
			].
	! !


!classDefinition: #CashierTest category: 'Ejercicio-Libros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'smalltalk80 designPatterns objectThinking catalog1 emptyCatalog catalog2 donQuixote workingCreditCard expiredCreditCard sales stolenCreditCard merchantProcessor fakeCreditCard creditCardWithoutMoney listToAdd emptyListToAdd listToAdd2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:04:23'!
setUp
	
	sales := OrderedCollection new.
	
	smalltalk80 := '9780201113723'.
	designPatterns := '9780201184624'.
	objectThinking := '9780735619654'.
	donQuixote := '9781400132171'.
	
	emptyCatalog := Dictionary new.
	
	catalog1 := Dictionary new.
	catalog1 add: smalltalk80 -> 10.
	catalog1 add: designPatterns -> 100.
	catalog1 add: objectThinking -> 50.
	
	catalog2 := Dictionary new.
	catalog2 add: donQuixote -> 50.
	
	emptyListToAdd := Dictionary new.
	
	listToAdd := Dictionary new.
	listToAdd add: donQuixote -> 1.
	
	listToAdd2 := Dictionary new.
	listToAdd2 add: smalltalk80 -> 3.
	listToAdd2 add: designPatterns -> 5.
	
	workingCreditCard := CreditCard forOwner: 'Marco' withNumber: '0000000000000000' withExpirationDate: FixedGregorianDate tomorrow.
	expiredCreditCard := CreditCard forOwner: 'Jorge' withNumber: '0000000000000000' withExpirationDate: FixedGregorianDate yesterday.
	stolenCreditCard := CreditCard forOwner: 'Gervasio' withNumber: '1234567891011120' withExpirationDate: FixedGregorianDate tomorrow.
	fakeCreditCard := CreditCard  forOwner: 'Pepe' withNumber: '1000000000000000' withExpirationDate: FixedGregorianDate tomorrow.
	creditCardWithoutMoney := CreditCard  forOwner: 'Ivan' withNumber: '1200000000000000' withExpirationDate: FixedGregorianDate tomorrow.
	
	merchantProcessor := MockMerchantProcesor new.
	merchantProcessor registerStolenCard: stolenCreditCard.
	merchantProcessor registerCard: workingCreditCard withBalance: 1000.
	merchantProcessor registerCard: creditCardWithoutMoney withBalance: 0.	! !

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:13:22'!
test01CashierCannotCheckoutWithAnEmptyCart
		
	self testCashierWithCatalog: emptyCatalog 
		cannotCheckoutCartWithCatalog: emptyCatalog 
		withItems: emptyListToAdd 
		withCreditCard: workingCreditCard 
		ThrowingError: Cashier errorCannotCheckoutEmptyCart.! !

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:13:22'!
test02CashierCannotCheckoutWithACartWithThatDoesntHaveAMatchingCatalog
		
	self testCashierWithCatalog: catalog1 
		cannotCheckoutCartWithCatalog: catalog2 
		withItems: listToAdd 
		withCreditCard:  workingCreditCard 
		ThrowingError: Cashier errorCannotCheckoutACartWithADifferentCatalog! !

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:18:05'!
test03CheckoutReturnsTheRightAmount
	
	self testCashierWithCatalog: catalog1 
		checkoutCartWithItems: listToAdd2 
		withCreditCard: workingCreditCard 
		asserting: [:aResult | self assert: 530 equals: aResult.]! !

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:13:22'!
test04CashierCannotCheckOutWithAnExpiredCard
	
	self testCashierWithCatalog: catalog1 
		cannotCheckoutCartWithCatalog: catalog1 
		withItems: listToAdd2  
		withCreditCard: expiredCreditCard 
		ThrowingError: Cashier errorExpiredCard.! !

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:19:13'!
test05CashierCheckoutRegistersSale
	
	self testCashierWithCatalog: catalog1 
	 	checkoutCartWithItems: listToAdd2 
		withCreditCard: workingCreditCard 
		asserting: [:aResult | self deny: sales isEmpty.
						self assert: 530 equals: (sales at: 1)].! !

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:13:22'!
test06CashierCannotCheckoutAStolenCard
	
	self testCashierWithCatalog: catalog1 
		cannotCheckoutCartWithCatalog: catalog1 
		withItems: listToAdd2 
		withCreditCard: stolenCreditCard 
		ThrowingError: Cashier errorStolenCard.! !

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:13:22'!
test07CashierCannotCheckoutWithAFakeCard
		
	self testCashierWithCatalog: catalog1 
		cannotCheckoutCartWithCatalog: catalog1 
		withItems: listToAdd2 
		withCreditCard: fakeCreditCard 
		ThrowingError: Cashier errorNotARegisteredCard.
	! !

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:13:22'!
test08CashierCannotCheckoutWithACardWithoutMoney
		
	self testCashierWithCatalog: catalog1 
		cannotCheckoutCartWithCatalog: catalog1 
		withItems: listToAdd2 
		withCreditCard: creditCardWithoutMoney 
		ThrowingError: Cashier errorCardDoesNotHaveEnoughBalance.
	! !

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:26:27'!
testCashierWithCatalog: aCatalog cannotCheckoutCartWithCatalog: aCartCatalog withItems: aListOfItemsAndAmounts withCreditCard: aCreditCard ThrowingError: anErrorMessage
	
	| cart cashier |
	
	cashier := Cashier withCatalog: aCatalog.
	
	cart := Cart createNewWithCatalog: aCartCatalog .
	
	aListOfItemsAndAmounts keysDo: [:anItem | cart add: anItem amount: (aListOfItemsAndAmounts at: anItem)].
	
	self should: [cashier checkout: cart 
					withCreditCard: aCreditCard
					onDate: FixedGregorianDate today 
					registerOn: sales 
					forMerchantProcessor: merchantProcessor]
		raise: Error 
		withExceptionDo: [
			:anError | 
			self assert: anError messageText = anErrorMessage.
			].! !

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 18:26:27'!
testCashierWithCatalog: aCatalog checkoutCartWithItems: aListOfItemsAndAmounts withCreditCard: aCreditCard asserting: anAssertionBlock
	
	| cart cashier result |
	
	cashier := Cashier withCatalog: aCatalog.
	
	cart := Cart createNewWithCatalog: aCatalog.
	
	aListOfItemsAndAmounts keysDo: [:anItem | cart add: anItem amount: (aListOfItemsAndAmounts at: anItem).].
	
	result := cashier checkout: cart 
		withCreditCard: aCreditCard
		onDate: FixedGregorianDate today 
		registerOn: sales 
		forMerchantProcessor: merchantProcessor.
		
	anAssertionBlock value: result.! !


!classDefinition: #CreditCardTest category: 'Ejercicio-Libros'!
TestCase subclass: #CreditCardTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!CreditCardTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 17:32:43'!
test01CreditCardCannotHaveEmptyOwner
	
	self testCreditCardFail: [CreditCard forOwner: '' withNumber: '0000000000000000' withExpirationDate: FixedGregorianDate today] 
		withErrorMessage: CreditCard errorOwnerEmpty.! !

!CreditCardTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 17:33:30'!
test02CreditCardNumberForACreditCardCannotHaveLessThan16Digits
	
	self testCreditCardFail: [CreditCard forOwner: 'Jorge' withNumber: ''  withExpirationDate: FixedGregorianDate today] 
		 withErrorMessage: CreditCard errorCardNumberLessThan16Digits.! !

!CreditCardTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 17:34:49'!
test03CreditCardNumberForACreditCardCannotHaveMoreThan16Digits
	
	self testCreditCardFail: [CreditCard forOwner: 'Jorge' withNumber: '00000000000000001'  withExpirationDate: FixedGregorianDate today]
		withErrorMessage: CreditCard errorCardNumberMoreThan16Digits.! !

!CreditCardTest methodsFor: 'testing' stamp: 'G.L.S 6/16/2021 17:31:36'!
testCreditCardFail: aBlockToFail withErrorMessage: anErrorMessage
	
	self should: aBlockToFail 
		raise: Error - MessageNotUnderstood
		withExceptionDo: [
			:anError |
			self assert: anError messageText = anErrorMessage].! !


!classDefinition: #Cart category: 'Ejercicio-Libros'!
Object subclass: #Cart
	instanceVariableNames: 'cartItems catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/9/2021 18:11:29'!
add: aBook 
	self add: aBook amount: 1.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:08:24'!
add: aBook amount: anAmount 
	| tuplaLibroCant |
	
	self assertBookIsAllowed: aBook.
	self assertAmountIsValid: anAmount.
	
	tuplaLibroCant := OrderedCollection new.
	tuplaLibroCant add: aBook.
	tuplaLibroCant add: anAmount.
	
	cartItems add: tuplaLibroCant.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/10/2021 13:49:35'!
assertAmountIsValid: anAmount.

	(anAmount isInteger) ifFalse: [self error: self class errorAmountNotInteger].
	(anAmount < 0) ifTrue: [self error: self class errorAmountNegative].
	(anAmount = 0) ifTrue: [self error: self class errorAmountZero].! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:00:17'!
assertBookIsAllowed: aBook

	(catalog keys includes: aBook) ifFalse:[self error: self class errorBookNotInAllowedList.].! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:08:23'!
first
	^cartItems first.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:00:17'!
hasCatalog: aCatalog
	^catalog = aCatalog.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:08:24'!
isEmpty
	^cartItems isEmpty.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:08:23'!
second
	^cartItems second.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:08:23'!
size
	^cartItems size.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:08:24'!
totalItemPrice
	
	^cartItems sum: [:bookAmountTuple | (catalog at: bookAmountTuple first) * bookAmountTuple second].! !


!Cart methodsFor: 'initialization' stamp: 'G.L.S 6/14/2021 19:08:24'!
initializeWith: anOrderedCollection
	catalog := anOrderedCollection.
	cartItems := OrderedCollection new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'Ejercicio-Libros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'G.L.S 6/16/2021 18:26:27'!
createNewWithCatalog: anOrderedCollection 
	^self new initializeWith: anOrderedCollection.! !


!Cart class methodsFor: 'errors' stamp: 'G.L.S 6/10/2021 13:40:37'!
errorAmountNegative
	^'Error - La cantidad no puede ser negativa'.! !

!Cart class methodsFor: 'errors' stamp: 'G.L.S 6/10/2021 13:35:33'!
errorAmountNotInteger
	^'Error - La cantidad tiene que ser un número entero'.! !

!Cart class methodsFor: 'errors' stamp: 'G.L.S 6/10/2021 13:49:02'!
errorAmountZero
	^'Error - La cantidad de libros no puede ser 0'.! !

!Cart class methodsFor: 'errors' stamp: 'G.L.S 6/9/2021 18:35:13'!
errorBookNotInAllowedList
	^'Error - El Libro no está en la lista de productos permitidos'.! !


!classDefinition: #Cashier category: 'Ejercicio-Libros'!
Object subclass: #Cashier
	instanceVariableNames: 'catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!Cashier methodsFor: 'private' stamp: 'G.L.S 6/14/2021 19:54:34'!
assertCard: aCreditCard hasNotExpiredOn: aDate.
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [self error: self class errorExpiredCard].! !

!Cashier methodsFor: 'private' stamp: 'G.L.S 6/15/2021 18:16:42'!
assertCard: aCreditCard isNotStolenFor: aMerchantProcessor

	(aMerchantProcessor isCardStolen: aCreditCard) ifTrue: [self error: self class errorStolenCard].! !

!Cashier methodsFor: 'private' stamp: 'G.L.S 6/16/2021 16:25:06'!
assertCard: aCreditCard isRegisteredOn: aMerchantProcessor
	
	(aMerchantProcessor isCardRegistered: aCreditCard) ifFalse: [self error: self class errorNotARegisteredCard].! !

!Cashier methodsFor: 'private' stamp: 'G.L.S 6/10/2021 20:49:32'!
assertCartHasTheSameCatalog: aCart

	(aCart hasCatalog: catalog) ifFalse: [self error: self class errorCannotCheckoutACartWithADifferentCatalog].! !

!Cashier methodsFor: 'private' stamp: 'G.L.S 6/10/2021 20:33:20'!
assertCartIsNotEmpty: aCart
	
	aCart isEmpty ifTrue: [self error: self class errorCannotCheckoutEmptyCart].! !


!Cashier methodsFor: 'operations' stamp: 'G.L.S 6/16/2021 17:21:01'!
assertCard: aCreditCard canSpend: aTotal on: aMerchantProcessor
	
	(aMerchantProcessor can: aCreditCard spend: aTotal) ifFalse: [self error: self class errorCardDoesNotHaveEnoughBalance]! !

!Cashier methodsFor: 'operations' stamp: 'G.L.S 6/16/2021 17:02:31'!
checkout: aCart withCreditCard: aCreditCard onDate: aDate registerOn: aSalesBook forMerchantProcessor: aMerchantProcessor    
	
	| total |
	
	self assertCartIsNotEmpty: aCart.
	self assertCartHasTheSameCatalog: aCart.
	self assertCard: aCreditCard hasNotExpiredOn: aDate.
	self assertCard: aCreditCard isNotStolenFor: aMerchantProcessor.
	self assertCard: aCreditCard isRegisteredOn: aMerchantProcessor.
	
	total := aCart totalItemPrice.
	
	self assertCard: aCreditCard canSpend: total on: aMerchantProcessor.
	
	aSalesBook add: total.
	
	^total.! !


!Cashier methodsFor: 'initialization' stamp: 'G.L.S 6/10/2021 20:45:21'!
initializeWithCatalog: aCatalog 
	catalog := aCatalog.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'Ejercicio-Libros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 6/10/2021 20:48:53'!
errorCannotCheckoutACartWithADifferentCatalog
	^'Error - No se puede hacer checkout de un carrito con un catálogo diferente'.! !

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 6/10/2021 20:01:29'!
errorCannotCheckoutEmptyCart
	^'Error - No se puede hacer checkout de un carrito vacío'.! !

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 6/16/2021 17:07:06'!
errorCardDoesNotHaveEnoughBalance

	^'Error - La tarjeta de crédito no tiene suficiente saldo'.! !

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 6/14/2021 19:41:47'!
errorExpiredCard
	^'Error - No se puede hacer checkout con una tarjeta de crédito vacía'.! !

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 6/16/2021 16:18:52'!
errorNotARegisteredCard
	^'Error - La tarjeta utilizada no se encuentra registrada'.! !

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 6/15/2021 18:14:08'!
errorStolenCard
	^'Error - No se puede realizar una transacción con una tarjeta robada'.! !


!Cashier class methodsFor: 'instance creation' stamp: 'G.L.S 6/10/2021 20:44:34'!
withCatalog: aDictionary 
	^self new initializeWithCatalog: aDictionary. ! !


!classDefinition: #CreditCard category: 'Ejercicio-Libros'!
Object subclass: #CreditCard
	instanceVariableNames: 'owner creditCardNumber expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!CreditCard methodsFor: 'initialization' stamp: 'G.L.S 6/14/2021 21:35:08'!
assertCardNumberIsCorrect: aCreditCardNumber

	(aCreditCardNumber size < 16) ifTrue: [self error: self class errorCardNumberLessThan16Digits].
	(aCreditCardNumber size > 16) ifTrue: [self error: self class errorCardNumberMoreThan16Digits].! !

!CreditCard methodsFor: 'initialization' stamp: 'G.L.S 6/14/2021 21:30:19'!
initializeForOwner: anOwner withNumber: aCreditCardNumber withExpirationDate: aDate 

	self assertNameNotEmpty: anOwner.
	self assertCardNumberIsCorrect: aCreditCardNumber.

	owner := anOwner.
	creditCardNumber := aCreditCardNumber.
	expirationDate := aDate.! !


!CreditCard methodsFor: 'private' stamp: 'G.L.S 6/14/2021 21:25:06'!
assertNameNotEmpty: anOwner
	
	anOwner withBlanksTrimmed isEmpty ifTrue: [self error: self class errorOwnerEmpty].! !


!CreditCard methodsFor: 'expiration' stamp: 'G.L.S 6/14/2021 19:50:01'!
isExpiredOn: aDate
	^ expirationDate < aDate.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'Ejercicio-Libros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'G.L.S 6/14/2021 19:39:49'!
forOwner: anOwner withNumber: aCreditCardNumber withExpirationDate: aDate
	^self new initializeForOwner: anOwner withNumber: aCreditCardNumber withExpirationDate: aDate ! !


!CreditCard class methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/14/2021 21:28:57'!
errorCardNumberLessThan16Digits
	^'Error - El número de la tarjeta de crédito tiene menos de 16 dígitos'.! !

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/14/2021 21:32:51'!
errorCardNumberMoreThan16Digits
	^'Error - El número de la tarjeta de crédito tiene más de 16 dígitos'.! !

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/14/2021 21:23:40'!
errorOwnerEmpty
	^'Error - El nombre dueño de la tarjeta de crédito no puede estar vacío'! !


!classDefinition: #MockMerchantProcesor category: 'Ejercicio-Libros'!
Object subclass: #MockMerchantProcesor
	instanceVariableNames: 'stolenCards registeredCards'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!MockMerchantProcesor methodsFor: 'initialization' stamp: 'G.L.S 6/16/2021 17:04:23'!
initialize

	stolenCards := OrderedCollection new.
	registeredCards := Dictionary new.! !


!MockMerchantProcesor methodsFor: 'operations' stamp: 'G.L.S 6/16/2021 17:08:12'!
can: aCreditCard spend: aTotal

	^ (registeredCards at:aCreditCard) >= aTotal.! !

!MockMerchantProcesor methodsFor: 'operations' stamp: 'G.L.S 6/16/2021 17:05:25'!
isCardRegistered: aCreditCard
	^registeredCards keys includes: aCreditCard.! !

!MockMerchantProcesor methodsFor: 'operations' stamp: 'G.L.S 6/15/2021 18:17:16'!
isCardStolen: aCreditCard

	^stolenCards includes: aCreditCard.! !

!MockMerchantProcesor methodsFor: 'operations' stamp: 'G.L.S 6/16/2021 17:04:50'!
registerCard: aCreditCard withBalance: aBalance  
	registeredCards add: aCreditCard -> aBalance.! !

!MockMerchantProcesor methodsFor: 'operations' stamp: 'G.L.S 6/15/2021 18:19:08'!
registerStolenCard: aCreditCard
	
	stolenCards add: aCreditCard.! !
