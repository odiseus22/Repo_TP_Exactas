!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
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

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #ReportTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReportTest
	instanceVariableNames: 'anAccount anAccount2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:49:10'!
setUp
	
	anAccount :=  ReceptiveAccount new.
	anAccount2 :=  ReceptiveAccount new.
	! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:38:21'!
test01AccountSummaryForAnAccountWithOutTransactionsShowsCorrectly

	|  result |

	result := OrderedCollection new.
	result add: 'Balance = 0'.
	
	self testAccountSummaryFor: anAccount WithTransactions: [] expecting: result.! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:38:34'!
test02AccountSummaryForAnAccountWithADepositShowsCorrectly

	| result |
	
	result := OrderedCollection new.
	result add: 'Depósito por 100'.
	result add: 'Balance = 100'.
	
	self testAccountSummaryFor: anAccount WithTransactions: [Deposit register: 100 on: anAccount.] expecting: result.! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:38:39'!
test03AccountSummaryForAnAccountWithAWithdrawShowsCorrectly

	| result |
	
	result := OrderedCollection new.
	result add: 'Extracción por 100'.
	result add: 'Balance = -100'.
	
	self testAccountSummaryFor: anAccount WithTransactions: [Withdraw register: 100 on: anAccount.] expecting: result.
	! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:52:06'!
test04AccountSummaryForAnAccountWithATransferenceShowsCorrectly

	| result |
	
	result := OrderedCollection new.
	result add: 'Salida por transferencia de 100'.
	result add: 'Balance = -100'.

	self testAccountSummaryFor: anAccount WithTransactions: [Transference register: 100 from: anAccount to: anAccount2.] expecting: result.

	
	result := OrderedCollection new.
	result add: 'Entrada por transferencia de 100'.
	result add: 'Balance = 100'.
	
	self testAccountSummaryFor: anAccount2 WithTransactions: [] expecting: result.! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:41:52'!
test05TransferNetForAnAccountWithOutTransactionsIsZero
	
	| result |

	result := 0.
	
	self testTransferNetFor: anAccount WithTransactions: [] expecting: result! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:42:51'!
test06TransferNetForAnAccountWithAtransferenceCalculatesCorrectly

	|  result |
	
	result := -100.

	self testTransferNetFor: anAccount WithTransactions: [Transference register: 100 from: anAccount to: anAccount2.] expecting: result.

	result := 100.
	
	self testTransferNetFor: anAccount2 WithTransactions: [] expecting: result! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:45:14'!
test07AccountSummaryWorksWithPortfolio

	| aPortfolio aPortfolioSummaryReport result |

	Deposit register: 10 on: anAccount.
	Deposit register: 10 on: anAccount2.
	Withdraw register: 20 on: anAccount2.
	Withdraw register: 20 on: anAccount.
	Transference register: 1000 from: anAccount to: anAccount2.
	aPortfolio := Portfolio with: anAccount with:anAccount2.
	aPortfolioSummaryReport := (AccountSummary for: aPortfolio) report.
	 
	result := OrderedCollection new.
	result add: 'Depósito por 10'. 
	result add: 'Extracción por 20'.
	result add: 'Salida por transferencia de 1000'.
	result add: 'Depósito por 10'.
	result add: 'Extracción por 20'.
	result add: 'Entrada por transferencia de 1000'.
	result add: 'Balance = -20'.
	
	self assert: result equals: aPortfolioSummaryReport.
	
	
	! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:44:04'!
test08TransferNetWorksWithPortfolio

	| aPortfolio aTransferNetReport  result |

	Deposit register: 10 on: anAccount.
	Deposit register: 10 on: anAccount2.
	Withdraw register: 20 on: anAccount2.
	Withdraw register: 20 on: anAccount.
	Transference register: 1000 from: anAccount to: anAccount2.

	aPortfolio := Portfolio with: anAccount.
	aTransferNetReport := (TransferNet for: aPortfolio) report.
	
	result := -1000.
	
	self assert: result equals: aTransferNetReport.
	! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:11:00'!
test09TreeReportShowsOnAnEmptyPortfolioOnlyShowsName

	| childrenPortfolio aPortfolioTreeReport result |
	childrenPortfolio := Portfolio named: 'Portfolio de hijos'.

	aPortfolioTreeReport := (PortfolioTreeReport for: childrenPortfolio) report.

	result := OrderedCollection new.
	result add: 'Portfolio de hijos'.

	self assert: result equals: aPortfolioTreeReport.
	
	! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:10:24'!
test10TreeReportForPopulatedPorfolioShowsCorrectly

	| angiesAccount childrenPortfolio johnsAccount aPortfolioTreeReport result familyPortfolio myAccount pepeAccount |
	johnsAccount := ReceptiveAccount named: 'Cuenta de Juan'.
	angiesAccount := ReceptiveAccount named: 'Cuenta de Angeles'.
	childrenPortfolio := Portfolio named: 'Portfolio de hijos' with: johnsAccount with: angiesAccount.
	myAccount := ReceptiveAccount named: 'Cuenta Mia'.
	familyPortfolio := Portfolio named: 'Portfolio de la familia' with:
	myAccount with: childrenPortfolio.
	pepeAccount := ReceptiveAccount named: 'Cuenta de pepe'.
	familyPortfolio add: pepeAccount.
	aPortfolioTreeReport := (PortfolioTreeReport for: familyPortfolio) report.

	result := OrderedCollection new.
	result add: 'Portfolio de la familia'.
	result add: '	Cuenta Mia'.
	result add: '	Portfolio de hijos'.
	result add: '		Cuenta de Juan'.
	result add: '		Cuenta de Angeles'.
	result add: '	Cuenta de pepe'.
	self assert: result equals: aPortfolioTreeReport.
	
	
! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:11:48'!
test11TreeSummaryReportShowsOnAnEmptyPortfolioOnlyShowsNameAndBalanceZero

	| childrenPortfolio aPortfolioTreeReport result |
	childrenPortfolio := Portfolio named: 'Portfolio de hijos'.

	aPortfolioTreeReport := (PortfolioTreeSummaryReport for: childrenPortfolio) report.

	result := OrderedCollection new.
	result add: 'Portfolio de hijos'.
	result add: '	Balance = 0'.

	self assert: result equals: aPortfolioTreeReport.
	
	
! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:12:41'!
test12TreeSummaryReportForPopulatedPorfolioShowsCorrectly

	| childrenPortfolio aPortfolioTreeReport result angiesAccount johnsAccount familyPortfolio myAccount |
	johnsAccount := ReceptiveAccount named: 'Cuenta de Juan'.
	angiesAccount := ReceptiveAccount named: 'Cuenta de Angeles'.
	childrenPortfolio := Portfolio named: 'Portfolio de hijos' with:
	johnsAccount with: angiesAccount.
	myAccount := ReceptiveAccount named: 'Cuenta Mia'.
	familyPortfolio := Portfolio named: 'Portfolio de la familia' with:
	myAccount with: childrenPortfolio.
	
	Withdraw register: 12  on: johnsAccount.
	Deposit register: 3312  on: angiesAccount.

	aPortfolioTreeReport := (PortfolioTreeSummaryReport for: familyPortfolio) report.

	result := OrderedCollection new.
	
	result add: 'Portfolio de la familia'.
	result add: '	Cuenta Mia'.
	result add: '		Balance = 0'.
	result add: '	Portfolio de hijos'.
	result add: '		Cuenta de Juan'.
	result add: '			Extracción por 12'.
	result add: '			Balance = -12'.
	result add: '		Cuenta de Angeles'.
	result add: '			Depósito por 3312'.
	result add: '			Balance = 3312'.
	result add: '		Balance = 3300'.
	result add: '	Balance = 3300'.

	self assert: result equals: aPortfolioTreeReport.
	
! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:37:13'!
testAccountSummaryFor: account WithTransactions: aTransactionBlock expecting: anExpectedList

    | anAccountSummaryReport |

    aTransactionBlock value.

    anAccountSummaryReport := (AccountSummary for: account) report.

    self assert: anExpectedList equals: anAccountSummaryReport.! !

!ReportTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 16:41:02'!
testTransferNetFor: account WithTransactions: aTransactionBlock expecting: anExpected

    | anAccountSummaryReport |

    aTransactionBlock value.

    anAccountSummaryReport := (TransferNet for: account) report.

    self assert: anExpected equals: anAccountSummaryReport.! !


!classDefinition: #TransferenceTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferenceTest
	instanceVariableNames: 'account account2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferenceTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 15:51:03'!
setUp

	account := ReceptiveAccount new.
	account2 := ReceptiveAccount new! !

!TransferenceTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 15:51:03'!
test01TransferenceModifyBalanceCorrectly

	Transference register: 10 from: account to: account2.
	
	self assert: -10 equals: account balance.
	self assert: 10 equals: account2 balance.! !

!TransferenceTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 15:51:03'!
test02TransferenceRegisterCorrectLegInAccounts

	| aTransference |

	aTransference := Transference register: 10 from: account to: account2.
	
	self assert:  (account hasRegistered: aTransference withdraw).
	self assert:  (account2 hasRegistered: aTransference deposit).! !

!TransferenceTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 15:51:03'!
test03TransferenceLegCanReachTheirTransference

	| aTransference aTransferenceDeposit aTransferenceWithdraw |

	
	aTransference := Transference register: 10 from: account to: account2.
	aTransferenceWithdraw := aTransference withdraw.
	aTransferenceDeposit :=  aTransference deposit.
	
	self assert: aTransferenceWithdraw parentTransference equals: aTransference.
	self assert: aTransferenceDeposit parentTransference equals: aTransference.
	
	
	! !

!TransferenceTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 15:53:47'!
test04TransferenceCanNotBeNegativeOrZero

	self testFailTransferenceWith: Transference errorInvalidTransferenceValue
		registering: -10
		from: account 
		to: account2.
		
	self testFailTransferenceWith: Transference errorInvalidTransferenceValue
		registering: 0
		from: account 
		to: account2.! !

!TransferenceTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 15:52:55'!
test05TransferenceFromAndToCanNotBeTheSameAccount

	self testFailTransferenceWith: Transference errorSameAccountTransference
		registering: 10
		from: account 
		to: account! !

!TransferenceTest methodsFor: 'tests' stamp: 'JRC 6/3/2021 15:51:42'!
testFailTransferenceWith: anErrorMessage registering: anAmount from: anAccount to: anAccount2

	self should:[Transference register: anAmount from: anAccount to: anAccount2.] raise: Error
	withExceptionDo: [:anError |
            self assert: anError messageText  = anErrorMessage.
            ].! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!Account methodsFor: 'private' stamp: 'JRC 6/3/2021 13:40:55'!
registerNameInReport: aReport.
	aReport registerAccountName: name.! !

!Account methodsFor: 'private' stamp: 'JRC 6/2/2021 17:25:52'!
sendTransactionsForReport: aReport

	self transactions do: [:aTransaction |
		aTransaction reportFor: aReport
		]! !


!Account methodsFor: 'initialization' stamp: 'JRC 6/3/2021 11:17:20'!
initializeNamed: aName 
	
	name := aName.
	self initialize.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Account class' category: 'Portfolio-Solucion'!
Account class
	instanceVariableNames: ''!

!Account class methodsFor: 'instance creation' stamp: 'JRC 6/3/2021 11:15:06'!
named: aName
	^self new initializeNamed: aName! !

!Account class methodsFor: 'instance creation' stamp: 'JRC 6/3/2021 11:24:13'!
named: aName with: anAccount
	
	^(self new initializeNamed: aName) add: anAccount; yourself.! !

!Account class methodsFor: 'instance creation' stamp: 'JRC 6/3/2021 11:22:58'!
named: aName with: anAccount with: anAccount2
	
	^((self new initializeNamed: aName) add: anAccount) add: anAccount2; yourself.! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !


!Portfolio methodsFor: 'private' stamp: 'JRC 6/3/2021 15:38:12'!
registerAccountForPortfolioReport: aReport 
	
	aReport registerPortfolio: self.! !

!Portfolio methodsFor: 'private' stamp: 'JRC 6/3/2021 13:54:46'!
registerBalanceInReport: aReport.
	aReport registerBalance: self balance.! !

!Portfolio methodsFor: 'private' stamp: 'JRC 6/3/2021 13:51:30'!
registerChildrenInReport: aReport.

	aReport registerPortfolioChildren: accounts. 
	
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'private' stamp: 'JRC 6/3/2021 15:38:12'!
registerAccountForPortfolioReport: aReport 
	
	aReport registerReceptiveAccount: self.
! !

!ReceptiveAccount methodsFor: 'private' stamp: 'JRC 6/3/2021 14:47:06'!
registerAccountSummaryInReport: aReport 
	
	aReport registerAccountSummaryFor: self.
	
	! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'private' stamp: 'JRC 6/2/2021 16:45:06'!
reportFor: aReport

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'private' stamp: 'JRC 6/2/2021 16:50:17'!
reportFor: aReport

	aReport reportADepositWithValue: value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferenceLegs category: 'Portfolio-Solucion'!
AccountTransaction subclass: #TransferenceLegs
	instanceVariableNames: 'parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferenceLegs methodsFor: 'as yet unclassified' stamp: 'JRC 5/30/2021 19:55:34'!
initializeFor: aTransference
	parent := aTransference ! !

!TransferenceLegs methodsFor: 'as yet unclassified' stamp: 'JRC 5/30/2021 21:55:45'!
value
	^parent value.! !


!TransferenceLegs methodsFor: 'accessing' stamp: 'JRC 5/30/2021 19:56:07'!
parentTransference
	^parent! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferenceLegs class' category: 'Portfolio-Solucion'!
TransferenceLegs class
	instanceVariableNames: ''!

!TransferenceLegs class methodsFor: 'as yet unclassified' stamp: 'JRC 5/30/2021 19:54:17'!
registerOn: aReceptiveAccount for: aTransference

	| transaction |
	
	transaction := self new initializeFor: aTransference.
	aReceptiveAccount register: transaction.
		
	^ transaction! !


!classDefinition: #DepositTransference category: 'Portfolio-Solucion'!
TransferenceLegs subclass: #DepositTransference
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!DepositTransference methodsFor: 'as yet unclassified' stamp: 'JRC 5/30/2021 19:51:03'!
affectBalance: aBalance

	^aBalance + (parent value)! !



!DepositTransference methodsFor: 'private' stamp: 'JRC 6/2/2021 16:51:52'!
reportFor: aReport

	aReport reportADepositTransferenceWithValue: parent value! !


!classDefinition: #WithdrawTransference category: 'Portfolio-Solucion'!
TransferenceLegs subclass: #WithdrawTransference
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!WithdrawTransference methodsFor: 'as yet unclassified' stamp: 'JRC 5/30/2021 19:50:46'!
affectBalance: aBalance

	^aBalance - (parent value) ! !



!WithdrawTransference methodsFor: 'private' stamp: 'JRC 6/2/2021 16:52:15'!
reportFor: aReport

	aReport reportAWithdrawTransferenceWithValue: parent value! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'private' stamp: 'JRC 6/2/2021 16:50:30'!
reportFor: aReport

	aReport reportAWithdrawWithValue: value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Report category: 'Portfolio-Solucion'!
Object subclass: #Report
	instanceVariableNames: 'account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Report methodsFor: 'initializate' stamp: 'JRC 6/3/2021 12:10:31'!
initializeFor: aReceptiveAccount
	self subclassResponsibility ! !


!Report methodsFor: 'report' stamp: 'JRC 6/2/2021 16:57:46'!
report
 	
	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Report class' category: 'Portfolio-Solucion'!
Report class
	instanceVariableNames: ''!

!Report class methodsFor: 'instance creation' stamp: 'JRC 5/31/2021 21:57:47'!
for: aReceptiveAccount 
	^self new initializeFor: aReceptiveAccount
! !


!classDefinition: #PortfolioReport category: 'Portfolio-Solucion'!
Report subclass: #PortfolioReport
	instanceVariableNames: 'level treeSummary'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioReport methodsFor: 'initializate' stamp: 'JRC 6/3/2021 15:21:53'!
initializeFor: anAccount 
	
	account := anAccount.
	level := 0.! !


!PortfolioReport methodsFor: 'report' stamp: 'JRC 6/3/2021 15:38:12'!
report

	treeSummary := OrderedCollection new.
	
	account registerAccountForPortfolioReport: self.
	
	^treeSummary! !


!PortfolioReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:23:47'!
registerAccountName: aName
	
	|tabulatedName|
	
	tabulatedName := self tabulateWithLevel: aName.
	
	treeSummary add: tabulatedName.! !

!PortfolioReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:38:12'!
registerPortfolioChildren: anAccountList
		
		self withIncreasedLevel: [
			anAccountList do: [:anAccount |
			anAccount registerAccountForPortfolioReport: self
			].
		]
		! !

!PortfolioReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:25:09'!
tabulateWithLevel: aLine

	| tabulatedName |
	tabulatedName := ''.
	
	level timesRepeat: [tabulatedName := tabulatedName,'	'].
	tabulatedName := tabulatedName, aLine.
	^tabulatedName.! !

!PortfolioReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:28:31'!
withIncreasedLevel: aBlock
		
		level := level+1.
		aBlock value.
		level := level-1.! !


!classDefinition: #PortfolioTreeReport category: 'Portfolio-Solucion'!
PortfolioReport subclass: #PortfolioTreeReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTreeReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:11:46'!
registerPortfolio: aPortfolio

	aPortfolio registerNameInReport: self.
	aPortfolio registerChildrenInReport: self.
! !

!PortfolioTreeReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:15:04'!
registerReceptiveAccount: anAccount

	anAccount registerNameInReport: self.! !


!classDefinition: #PortfolioTreeSummaryReport category: 'Portfolio-Solucion'!
PortfolioReport subclass: #PortfolioTreeSummaryReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTreeSummaryReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:29:58'!
registerAccountSummaryFor: anAccount

	| anAccountSummaryReport |

	self withIncreasedLevel: [
		anAccountSummaryReport := (AccountSummary for: anAccount) report.
	
		anAccountSummaryReport do: [
			:aLine |
			treeSummary add: (self tabulateWithLevel: aLine)
			 ].
	].
! !

!PortfolioTreeSummaryReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:30:36'!
registerBalance: aBalance
	
	| aTabulatedBalanceValueLine |
	
	self withIncreasedLevel: [
		aTabulatedBalanceValueLine := self tabulateWithLevel: ('Balance = ', aBalance asString).
		treeSummary add: aTabulatedBalanceValueLine.
	]
	
	
! !

!PortfolioTreeSummaryReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:25:00'!
registerPortfolio: aPortfolio

	aPortfolio registerNameInReport: self.
	aPortfolio registerChildrenInReport: self.
	aPortfolio registerBalanceInReport: self.
! !

!PortfolioTreeSummaryReport methodsFor: 'private' stamp: 'JRC 6/3/2021 14:45:48'!
registerReceptiveAccount: anAccount

	anAccount registerNameInReport: self.
	anAccount registerAccountSummaryInReport: self.
! !


!classDefinition: #TransferenceReport category: 'Portfolio-Solucion'!
Report subclass: #TransferenceReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferenceReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:33:44'!
reportADepositTransferenceWithValue: aValue
	
	self subclassResponsibility ! !

!TransferenceReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:34:02'!
reportADepositWithValue: aValue
	
	self subclassResponsibility ! !

!TransferenceReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:34:15'!
reportAWithdrawTransferenceWithValue: aValue
	
	self subclassResponsibility ! !

!TransferenceReport methodsFor: 'private' stamp: 'JRC 6/3/2021 15:34:25'!
reportAWithdrawWithValue: aValue
	
	self subclassResponsibility ! !


!TransferenceReport methodsFor: 'initializate' stamp: 'JRC 6/3/2021 15:35:29'!
initializeFor: aReceptiveAccount
	account := aReceptiveAccount.! !


!classDefinition: #AccountSummary category: 'Portfolio-Solucion'!
TransferenceReport subclass: #AccountSummary
	instanceVariableNames: 'accountSummaryLines'
	classVariableNames: 'AccountSummaryLines'
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummary methodsFor: 'private' stamp: 'JRC 6/2/2021 17:00:42'!
reportADepositTransferenceWithValue: aValue

	accountSummaryLines add: 'Entrada por transferencia de ', aValue asString.! !

!AccountSummary methodsFor: 'private' stamp: 'JRC 6/2/2021 17:02:40'!
reportADepositWithValue: aValue

	accountSummaryLines add: 'Depósito por ', aValue asString.! !

!AccountSummary methodsFor: 'private' stamp: 'JRC 6/2/2021 17:02:03'!
reportAWithdrawTransferenceWithValue: aValue

	accountSummaryLines add: 'Salida por transferencia de ', aValue asString.! !

!AccountSummary methodsFor: 'private' stamp: 'JRC 6/2/2021 17:02:27'!
reportAWithdrawWithValue: aValue

	accountSummaryLines add: 'Extracción por ', aValue asString.! !



!AccountSummary methodsFor: 'report' stamp: 'JRC 6/2/2021 17:06:15'!
report

	|aBalance|
	
	accountSummaryLines := OrderedCollection new.
	
	account sendTransactionsForReport: self.
	
	aBalance := account balance.
	
	accountSummaryLines add: 'Balance = ', aBalance asString.
	
	^accountSummaryLines! !


!classDefinition: #TransferNet category: 'Portfolio-Solucion'!
TransferenceReport subclass: #TransferNet
	instanceVariableNames: 'transferNetValue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNet methodsFor: 'report' stamp: 'JRC 6/2/2021 17:14:31'!
report

	transferNetValue := 0.
	
	account sendTransactionsForReport: self.
	
	^transferNetValue.! !


!TransferNet methodsFor: 'private' stamp: 'JRC 6/2/2021 17:16:04'!
reportADepositTransferenceWithValue: aValue
	
	transferNetValue := transferNetValue + aValue ! !

!TransferNet methodsFor: 'private' stamp: 'JRC 6/2/2021 17:10:42'!
reportADepositWithValue: aValue
	
! !

!TransferNet methodsFor: 'private' stamp: 'JRC 6/2/2021 17:16:11'!
reportAWithdrawTransferenceWithValue: aValue
	
	transferNetValue := transferNetValue - aValue ! !

!TransferNet methodsFor: 'private' stamp: 'JRC 6/2/2021 17:10:48'!
reportAWithdrawWithValue: aValue
	
! !



!classDefinition: #Transference category: 'Portfolio-Solucion'!
Object subclass: #Transference
	instanceVariableNames: 'amount receptiveAccount receptiveAccount2 withdraw deposit value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transference methodsFor: 'initialization' stamp: 'JRC 5/30/2021 21:52:58'!
initializeRegister: anAmount from: aReceptiveAccount to: aReceptiveAccount2 
	
	withdraw := WithdrawTransference registerOn: aReceptiveAccount for: self.
	deposit := DepositTransference registerOn: aReceptiveAccount2 for: self.
	value := anAmount.
	
! !


!Transference methodsFor: 'Value' stamp: 'JRC 5/30/2021 19:52:03'!
value
	^value! !


!Transference methodsFor: 'Legs' stamp: 'JRC 5/30/2021 19:17:02'!
deposit
	^deposit! !

!Transference methodsFor: 'Legs' stamp: 'JRC 5/30/2021 19:16:39'!
withdraw
	^withdraw! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transference class' category: 'Portfolio-Solucion'!
Transference class
	instanceVariableNames: ''!

!Transference class methodsFor: 'instance creation' stamp: 'JRC 6/2/2021 16:10:05'!
errorInvalidTransferenceValue
	^'ERROR No se permiten transferencias con valor negativo o nulo.'! !

!Transference class methodsFor: 'instance creation' stamp: 'JRC 6/2/2021 16:14:10'!
register: anAmount from: aReceptiveAccount to: aReceptiveAccount2

	anAmount <=0 ifTrue:[self error: self errorInvalidTransferenceValue].
	 aReceptiveAccount = aReceptiveAccount2 ifTrue:[self error: self errorSameAccountTransference].
	^self new initializeRegister:anAmount from: aReceptiveAccount to: aReceptiveAccount2 
	
	! !


!Transference class methodsFor: 'Errors' stamp: 'JRC 6/2/2021 16:15:59'!
errorSameAccountTransference
	^'ERROR No se permiten transferencias entre la misma cuenta'! !
