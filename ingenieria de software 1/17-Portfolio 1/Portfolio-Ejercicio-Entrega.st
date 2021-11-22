!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: 'portfolio portfolio2 portfolio3 portfolio4 account account2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:21:57'!
test01BalanceOfEmptyPortfolioEquals0

	self testBalanceOfAPortfolioWithTransactions: [] ElementsToAdd: {} EqualsATotalOf: 0.! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:22:42'!
test02BalanceOfAPortfolioWithAnAccountEqualsAccountBalance
	
	self testBalanceOfAPortfolioWithTransactions: [Deposit register: 100 on: account.] ElementsToAdd: {account}  EqualsATotalOf: 100. ! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:25:16'!
test03BalanceOfAPortfolioWithMultipleAccountsEqualsTheTotalBalanceOfTheAccounts
	
	self testBalanceOfAPortfolioWithTransactions: [
		Deposit register: 200 on: account.
		Withdraw register: 50 on: account2.
		]  
		ElementsToAdd: {account. account2} EqualsATotalOf: 150.! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 16:58:24'!
test04EmptyPortfolioTransactionsAreAnEmptyCollection
	
	self assert: OrderedCollection new equals: portfolio transactions.! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 16:58:40'!
test05TransactionsOfAPortfolioWithOneAccountEqualsTheAccountTransactions

	Deposit register: 100 on: account.
	portfolio addPortfolioElement: account.
	
	self assert: account transactions equals: portfolio transactions.! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:39:39'!
test06hasRegisteredOnAPortfolioWithAnAccountOnAnExistingTransactionReturnsTrue

	|deposit|
	deposit := Deposit register: 100 on: account.
	portfolio addPortfolioElement: account.
	
	self assert: (portfolio hasRegistered: deposit).! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:15:32'!
test07hasRegisteredDoesNotReturnTrueOnATransactionOfAnAccountNotInsideThePortfolio

	|deposit|

	deposit := Deposit register: 100 on: account2.
	portfolio addPortfolioElement: account.
	
	self deny: (portfolio hasRegistered: deposit).! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:07:34'!
test08PortfolioCantHaveMultiplesOfTheSameAccount
	
	self testAccountAlreadyExistsFor: [
			portfolio addPortfolioElement: account.
			portfolio addPortfolioElement: account.
			].! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:07:01'!
test09PortfolioCantHaveMultipleOfTheSameAccountByAddingAnotherPortfolioWithTheAccounts
	
	self testAccountAlreadyExistsFor: [
			portfolio2 addPortfolioElement: account.
			portfolio addPortfolioElement: account.
			portfolio addPortfolioElement: portfolio2.
			].! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:00:07'!
test10PortfolioCanHaveAnotherPortfolioWithDifferentAccounts

	|errorHappened|
	
	errorHappened := #No.
	
	[	portfolio2 addPortfolioElement: account.
		portfolio addPortfolioElement: account2.
		portfolio addPortfolioElement: portfolio2.]
		on: Error
		do: [:anError|
			errorHappened := #Si.
			].
	
	self assert: #No equals: errorHappened.
! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:03:53'!
test11PortfolioCannotContainItself

	self testPorfolioAlreadyExistsFor: [portfolio addPortfolioElement: portfolio].
	 
! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:04:20'!
test12PortfolioCannotContainTheSamePortfolioInMultipleLevels
	
	self testPorfolioAlreadyExistsFor: [
			portfolio addPortfolioElement: portfolio2.
			portfolio2 addPortfolioElement: portfolio3.
			portfolio2 addPortfolioElement: portfolio3.
			].
	 
! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:05:08'!
test13PortfolioCannotHaveAPortfolioContainedInAHigherLevel

	self testPorfolioAlreadyExistsFor: [
			portfolio addPortfolioElement: portfolio3.
			portfolio addPortfolioElement: portfolio2.
			portfolio2 addPortfolioElement: portfolio3.
			].
	 
! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:05:25'!
test14PortfoliosCannotContainEachOther
	
	self testPorfolioAlreadyExistsFor: [
			portfolio addPortfolioElement: portfolio2.
			portfolio2 addPortfolioElement: portfolio.
			].
	 
! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:06:39'!
test15PortfolioCannotContainACopyOfTheSamePortfolioInAHigherLevelWithMultipleParents
	
	self testAccountAlreadyExistsFor:[
			portfolio3 addPortfolioElement: portfolio4.
			portfolio addPortfolioElement: portfolio3.
			portfolio2 addPortfolioElement: portfolio3.
			portfolio addPortfolioElement: account.
			portfolio3 addPortfolioElement: account.
			].
	 
! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:09:23'!
testAccountAlreadyExistsFor: aBlock
	
	self testPorfolioErrorFor: aBlock expecting: Portfolio AccountAlreadyExistsError.! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:21:13'!
testBalanceOfAPortfolioWithTransactions: aBlockWithTransactions ElementsToAdd: anArrayOfPortfolioElements EqualsATotalOf: aTotalToCompare 

	aBlockWithTransactions value.
	anArrayOfPortfolioElements do: [:aPortfolioElement | portfolio addPortfolioElement: aPortfolioElement.].
	
	self assert: aTotalToCompare equals: portfolio balance.! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:09:47'!
testPorfolioAlreadyExistsFor: aBlock
	
	self testPorfolioErrorFor: aBlock expecting: Portfolio PortfolioAlreadyExistsError.
	 
! !

!PortfolioTest methodsFor: 'testing' stamp: 'G.L.S. 5/24/2021 17:09:23'!
testPorfolioErrorFor: aBlock expecting: anErrorMessage
	
	self should: aBlock
		raise: Error
		withExceptionDo: [:anError |
			self assert: anError messageText  = anErrorMessage.
			].
	 
! !


!PortfolioTest methodsFor: 'setUp/tearDown' stamp: 'G.L.S. 5/24/2021 16:57:25'!
setUp

portfolio  _ Portfolio new.
portfolio2  _ Portfolio new.
portfolio3  _ Portfolio new.
portfolio4  _ Portfolio new.

account _ ReceptiveAccount new.
account2 _ ReceptiveAccount new.! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'private' stamp: 'G.L.S. 5/20/2021 20:16:36'!
performOperationOnBalance: aTotal
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'private' stamp: 'G.L.S. 5/20/2021 20:16:36'!
performOperationOnBalance: aTotal
	
	^aTotal + value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'G.L.S. 5/17/2021 20:35:20'!
value

	^ value! !


!Withdraw methodsFor: 'private' stamp: 'G.L.S. 5/20/2021 20:16:36'!
performOperationOnBalance: aTotal
	
	^aTotal - value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Object subclass: #Portfolio
	instanceVariableNames: 'portfolioElements parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'balance' stamp: 'G.L.S. 5/23/2021 21:10:36'!
balance
	^portfolioElements sum: [:aPortfolioElement | aPortfolioElement balance] ifEmpty: [0].! !


!Portfolio methodsFor: 'accountManagement' stamp: 'G.L.S. 5/24/2021 15:29:23'!
addPortfolioElement: aNewPortfolioElement
	|roots|
	
	roots := self oldestParent.
	
	(roots includes: aNewPortfolioElement) ifTrue: [self error: self class PortfolioAlreadyExistsError].
	roots do: [:root | (root allElements anySatisfy: [:aPortfolioElement | aNewPortfolioElement hasOrIs: aPortfolioElement]) ifTrue: [self error: self class AccountAlreadyExistsError].].
	
	aNewPortfolioElement addTo: self.! !

!Portfolio methodsFor: 'accountManagement' stamp: 'G.L.S. 5/24/2021 14:44:01'!
hasOrIs: aNewPortfolioElement
	
	(self = aNewPortfolioElement) ifTrue: [self error: self class PortfolioAlreadyExistsError].	
	^(portfolioElements anySatisfy: [:aPortfolioElement | aPortfolioElement hasOrIs: aNewPortfolioElement])! !


!Portfolio methodsFor: 'initialization' stamp: 'G.L.S. 5/24/2021 15:17:43'!
initialize
	portfolioElements := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'transactions' stamp: 'G.L.S. 5/23/2021 21:10:36'!
transactions
	|totalTransactions|
	
	totalTransactions := OrderedCollection new.
	
	portfolioElements do: [:anAccount | totalTransactions addAll: anAccount transactions].
	
	^totalTransactions.! !


!Portfolio methodsFor: 'private' stamp: 'G.L.S. 5/23/2021 23:09:38'!
addAccount: anAccount.
	portfolioElements add: anAccount.! !

!Portfolio methodsFor: 'private' stamp: 'G.L.S. 5/24/2021 15:18:04'!
addParent: aPortfolio
	parents add: aPortfolio.! !

!Portfolio methodsFor: 'private' stamp: 'G.L.S. 5/24/2021 15:15:47'!
addPortfolio:  aPortfolio.
	aPortfolio addParent: self.
	portfolioElements add: aPortfolio. ! !

!Portfolio methodsFor: 'private' stamp: 'G.L.S. 5/23/2021 23:12:01'!
addTo: aPortfolio.
	aPortfolio addPortfolio: self.! !

!Portfolio methodsFor: 'private' stamp: 'G.L.S. 5/24/2021 14:36:55'!
allElements
	
	|totalAccounts|
	
	totalAccounts := OrderedCollection new.
	totalAccounts addAll: portfolioElements.
	
	self portfolios do: [:aPortfolio | totalAccounts addAll: aPortfolio allElements].
	
	^totalAccounts.! !

!Portfolio methodsFor: 'private' stamp: 'G.L.S. 5/24/2021 15:44:36'!
oldestParent
	|noParentsCollection parentsCollection|
	
	noParentsCollection := OrderedCollection new.
	
	(parents isEmpty) ifTrue:[
		noParentsCollection add:self.
		^noParentsCollection].
	
	parentsCollection := OrderedCollection new.
	
	(parents collect: [:aParent | aParent oldestParent] )do: [
		:aCollection |
		parentsCollection addAll: aCollection.
		].
	
	^parentsCollection.! !

!Portfolio methodsFor: 'private' stamp: 'G.L.S. 5/23/2021 21:10:36'!
portfolios
	^(portfolioElements select:[:aPortfolioElement | aPortfolioElement class = Portfolio]).! !


!Portfolio methodsFor: 'Registrations' stamp: 'G.L.S. 5/23/2021 21:10:36'!
hasRegistered: aTransaction
	^ portfolioElements anySatisfy: [:aPortfolioElement | aPortfolioElement hasRegistered: aTransaction].
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'initialization' stamp: 'G.L.S. 5/17/2021 21:52:43'!
createNew

	^Portfolio new initialize.! !


!Portfolio class methodsFor: 'errors' stamp: 'G.L.S. 5/23/2021 19:17:03'!
AccountAlreadyExistsError
	^'La cuenta ya existe!!!!!!'! !

!Portfolio class methodsFor: 'errors' stamp: 'G.L.S. 5/23/2021 22:20:21'!
PortfolioAlreadyExistsError
	^'Ya existe este portfolio'! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Object subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'G.L.S. 5/20/2021 20:16:36'!
balance
	
	|total|
	
	total := 0.
	
	transactions do: [:aTransaction | total := aTransaction performOperationOnBalance: total].
	
	^total.! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !


!ReceptiveAccount methodsFor: 'as yet unclassified' stamp: 'G.L.S. 5/23/2021 23:09:12'!
addTo: aPortfolio
	aPortfolio addAccount: self.! !

!ReceptiveAccount methodsFor: 'as yet unclassified' stamp: 'G.L.S. 5/24/2021 14:36:13'!
hasOrIs: aReceptiveAccount
	^self = aReceptiveAccount.! !
