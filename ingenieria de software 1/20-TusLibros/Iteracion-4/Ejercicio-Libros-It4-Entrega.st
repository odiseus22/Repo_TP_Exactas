!classDefinition: #LibrosClientCartWindow category: 'Ejercicio-Libros'!
Panel subclass: #LibrosClientCartWindow
	instanceVariableNames: 'addToCartButton removeFromCartButton checkOutCartButton logoutButton storeItemsList cartItemsList storeListColumn cartListColumn buttonsColumn itemAmountTextBox'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 19:03:41'!
addButtons
	
	| layout1 layout2 |
	
	layout1 := LayoutMorph newColumn.
	layout2 := LayoutMorph newColumn.
	
	layout1 axisEdgeWeight: 0.5.
	layout2 axisEdgeWeight: 0.5.
	
	layout1 addMorph: (LabelMorph contents: 'Cantidad de items a manipular').
	layout1 addMorph: itemAmountTextBox.
	
	layout2 addMorph: addToCartButton.
	layout2 addMorph: removeFromCartButton.
	layout2 addMorph: checkOutCartButton.
	layout2 addMorph: logoutButton.
	
	buttonsColumn  addMorph: layout1.
	buttonsColumn  addMorph: layout2.
	
	
	
	
	

	! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 16:59:47'!
addCartList
	
	cartListColumn addMorph: (LabelMorph contents: 'Items del carrito actual').
	cartListColumn addMorph: 	cartItemsList.
	
	! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 16:38:28'!
addLayouts

	self layoutMorph addMorph:  storeListColumn.
	self layoutMorph addMorph:  cartListColumn.
	self layoutMorph addMorph:  buttonsColumn.
	! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 16:59:26'!
addStoreList
	
	storeListColumn addMorph: (LabelMorph contents: 'Catalogo de la Tienda').
	storeListColumn addMorph: storeItemsList.

	! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 18:29:30'!
buildMorphicWindow
	
	self layoutMorph beRow.
	
	self createLayoutColumns.
	self createAddToCartButton.
	self createRemoveFromCartButton.
	self createCheckoutButton.
	self createLogoutButton.
	self createStoreItemList.
	self createCartItemList.
	self createCartItemAMountTextbox.
	
	self addStoreList.
	self addCartList.
	self addButtons.
	
	self addLayouts.
	! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 20:42:07'!
createAddToCartButton
	
	addToCartButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #addSelectedItemToCart
								label: 'Add to cart'.	
	
	addToCartButton layoutSpec proportionalWidth: 0.8.! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 19:02:43'!
createCartItemAMountTextbox

	
	
	itemAmountTextBox := TextModelMorph textProvider: self model textGetter: #itemAmountText textSetter: #itemAmountText:. 
	itemAmountTextBox textMorph setProperty: #keyStroke: toValue: [ :key | itemAmountTextBox textMorph acceptContents ] .
	itemAmountTextBox borderWidth: 1; borderColor: Color skyBlue; morphWidth: 300.
	
	itemAmountTextBox layoutSpec fixedHeight: 30.
	! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 16:57:05'!
createCartItemList

	cartItemsList := PluggableListMorph model: self model listGetter: #getCartItemList indexGetter: #cartItemListIndex indexSetter: #cartItemListIndex:.
	cartItemsList  borderColor: Color skyBlue; borderWidth: 1; morphWidth: 300.
	
	cartItemsList layoutSpec proportionalHeight: 0.85.
	
	
	! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 20:41:32'!
createCheckoutButton
	
	checkOutCartButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #checkoutCart
								label: 'Checkout'.
	
	checkOutCartButton layoutSpec proportionalWidth: 0.8.
	! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 18:56:27'!
createLayoutColumns

	storeListColumn := LayoutMorph newColumn.
	cartListColumn := LayoutMorph newColumn.
	buttonsColumn := LayoutMorph newColumn.
	
	storeListColumn axisEdgeWeight: 0.5.
	cartListColumn axisEdgeWeight: 0.5.
	buttonsColumn axisEdgeWeight: 0.5.! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 20:41:42'!
createLogoutButton
	
	logoutButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #logout
								label: 'Logout'.
	
	logoutButton layoutSpec proportionalWidth: 0.8.
	! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 20:41:52'!
createRemoveFromCartButton

	removeFromCartButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #removeSelectedItemFromCart
								label: 'Remove from cart'.	

	removeFromCartButton layoutSpec proportionalWidth: 0.8.
	
	! !

!LibrosClientCartWindow methodsFor: 'Interface Creation' stamp: 'G.L.S 7/6/2021 16:57:21'!
createStoreItemList
	
	storeItemsList := PluggableListMorph model: self model listGetter: #getStoreItemList indexGetter: #storeItemListIndex indexSetter: #storeItemListIndex:.
	storeItemsList  borderColor: Color skyBlue; borderWidth: 1; morphWidth: 300.
	
	storeItemsList layoutSpec proportionalHeight: 0.85.
	
	
	
	! !


!LibrosClientCartWindow methodsFor: 'error windows' stamp: 'G.L.S 7/8/2021 16:13:37'!
showError
	LibrosClientErrorWindow withModel: self model.! !


!LibrosClientCartWindow methodsFor: 'window closing' stamp: 'G.L.S 7/7/2021 23:23:10'!
closeWindow
	
	Preferences dismissAllOnOptionClose ifTrue:
		[Sensor rawMacOptionKeyPressed ifTrue:
			[^ self world closeUnchangedWindows]].
	self delete.

	! !

!LibrosClientCartWindow methodsFor: 'window closing' stamp: 'G.L.S 7/7/2021 23:23:02'!
returnToLogin
	
	LibrosClientLoginWindow open.
	
	self closeWindow.

	! !


!LibrosClientCartWindow methodsFor: 'initialization' stamp: 'G.L.S 7/8/2021 16:21:24'!
initializeWith: aModel

	self titleMorph showButtonsNamed: #( close collapse ).
	self model: aModel.
	self setLabel: 'Gestion de carrito'.
	self morphExtent: (self defaultExtent).
	self buildMorphicWindow.
	self openInWorld.
	
	self model when: #logout send: #returnToLogin to: self.
	
	self model when: #itemAddedToCart send: #refreshCartList to: self.
	self model when: #itemRemovedFromCart send: #refreshCartList to: self.
	self model when: #checkoutSuccessful send: #showCheckoutTicket to: self.
	self model when: #lougout send: #returnToLogin to: self.
	
	self model when: #errorHappened send: #showError to: self.
	
	self refreshCartList.
	! !


!LibrosClientCartWindow methodsFor: 'windows' stamp: 'G.L.S 7/8/2021 00:24:48'!
showCheckoutTicket
	
	LibrosClientTicketWindow withModel: self model.
	self closeWindow.
	
	
	
	! !


!LibrosClientCartWindow methodsFor: 'private' stamp: 'G.L.S 7/3/2021 21:08:48'!
defaultExtent
	
	^1035@485.
! !

!LibrosClientCartWindow methodsFor: 'private' stamp: 'G.L.S 7/7/2021 18:31:32'!
refreshCartList
	
	self model listCart.
	
	cartItemsList updateList.
	"cartItemsList setSelectionIndex: 0."! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LibrosClientCartWindow class' category: 'Ejercicio-Libros'!
LibrosClientCartWindow class
	instanceVariableNames: ''!

!LibrosClientCartWindow class methodsFor: 'as yet unclassified' stamp: 'G.L.S 7/3/2021 20:12:00'!
withModel: aModel
	
	^self new initializeWith: aModel.! !


!classDefinition: #LibrosClientErrorWindow category: 'Ejercicio-Libros'!
Panel subclass: #LibrosClientErrorWindow
	instanceVariableNames: 'description'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!LibrosClientErrorWindow methodsFor: 'private' stamp: 'G.L.S 7/3/2021 19:57:06'!
errorMessagePanning

	^50@0.! !


!LibrosClientErrorWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/3/2021 19:56:48'!
buildMorphicWindow
	
	| errorLabel |
	errorLabel := LabelMorph contents: description.
	
	self layoutMorph
		beRow;
		axisEdgeWeight: 0.5;
		addMorph: (errorLabel).
	
	self morphExtent: (errorLabel minimumExtent + self errorMessagePanning).! !


!LibrosClientErrorWindow methodsFor: 'initialization' stamp: 'G.L.S 7/8/2021 15:43:06'!
withModel: aModel 
	
	description := aModel errorMessage.
	self titleMorph showButtonsNamed: #( close collapse ).
	self setLabel: 'ERROR'.
	self buildMorphicWindow.
	self openInWorld.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LibrosClientErrorWindow class' category: 'Ejercicio-Libros'!
LibrosClientErrorWindow class
	instanceVariableNames: ''!

!LibrosClientErrorWindow class methodsFor: 'as yet unclassified' stamp: 'G.L.S 7/8/2021 16:12:23'!
withModel: aModel 

	^self new withModel: aModel.! !


!classDefinition: #LibrosClientLoginWindow category: 'Ejercicio-Libros'!
Panel subclass: #LibrosClientLoginWindow
	instanceVariableNames: 'usernameTextMorph userpasswordTextMorph createCartButton listPurchasesButton'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!LibrosClientLoginWindow methodsFor: 'initialization' stamp: 'G.L.S 7/8/2021 16:19:54'!
initializeWith: aTitle

	self titleMorph showButtonsNamed: #( close collapse ).
	self setLabel: aTitle.
	self model: (LibrosClientModel new).
	self morphExtent: (self defaultExtent).
	self buildMorphicWindow.
	self openInWorld.
	
	self model when: #successfullyCreatedCart send: #showCartWindow to: self.
	self model when: #successfullyListedPurchases send: #showPurchasesWindow to: self.
	
	self model when: #errorHappened send: #showError to: self.! !


!LibrosClientLoginWindow methodsFor: 'windows' stamp: 'G.L.S 7/3/2021 20:38:34'!
buildMorphicWindow

	self layoutMorph beColumn; 
	axisEdgeWeight: 0.5;
	separation: 25.

	self createUsernameTextMorph.
	self createUserpasswordTextMorph.
	self createCreateCartButton.
	self createListPurchasesButton.
	
	self setButtonsWidth.
	
	self addUsernameInput.
	self addUserpasswordInput.
	self addCreateCartButton.
	self addListPurchasesButton.! !

!LibrosClientLoginWindow methodsFor: 'windows' stamp: 'G.L.S 7/8/2021 14:36:59'!
showCartWindow

	LibrosClientCartWindow withModel: self model.
	self closeWindow.! !

!LibrosClientLoginWindow methodsFor: 'windows' stamp: 'G.L.S 7/8/2021 16:19:04'!
showError
	
	LibrosClientErrorWindow withModel: self model.! !

!LibrosClientLoginWindow methodsFor: 'windows' stamp: 'G.L.S 7/7/2021 23:25:37'!
showPurchasesWindow
	
	LibrosClientPurchasesWindow withModel: self model.
	self closeWindow.! !


!LibrosClientLoginWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/3/2021 20:32:36'!
addCreateCartButton
	
	self layoutMorph addMorph: createCartButton.! !

!LibrosClientLoginWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/3/2021 20:33:04'!
addListPurchasesButton

	self layoutMorph addMorph: listPurchasesButton.! !

!LibrosClientLoginWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/3/2021 16:59:29'!
addUsernameInput

	self layoutMorph
		addMorph: (LabelMorph contents: 'Usuario');
		addMorph: usernameTextMorph.
! !

!LibrosClientLoginWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/3/2021 17:00:04'!
addUserpasswordInput
	
	self layoutMorph 
		addMorph: (LabelMorph contents: 'Contraseña');
		addMorph: userpasswordTextMorph.
! !

!LibrosClientLoginWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/3/2021 20:38:17'!
createCreateCartButton

	createCartButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #tryToCreateCartWithUserCredentials
								label: 'Create Cart'.
! !

!LibrosClientLoginWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/3/2021 20:32:20'!
createListPurchasesButton.

	listPurchasesButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #tryToListPurchasesWithUserCredentials
								label: 'List Purchases'.
	
	! !

!LibrosClientLoginWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/3/2021 17:02:48'!
createUsernameTextMorph
	
	usernameTextMorph := TextModelMorph textProvider: self model textGetter: #usernameText textSetter: #usernameText:. 
   	usernameTextMorph textMorph setProperty: #keyStroke: toValue: [ :key | usernameTextMorph textMorph acceptContents ].
    	usernameTextMorph borderWidth: 1; borderColor: Color skyBlue; morphWidth: 300. 
    	usernameTextMorph morphHeight: 10.
	! !

!LibrosClientLoginWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/3/2021 17:02:57'!
createUserpasswordTextMorph

	userpasswordTextMorph := TextModelMorph textProvider: self model textGetter: #userpasswordText textSetter: #userpasswordText:. 
   	userpasswordTextMorph textMorph setProperty: #keyStroke: toValue: [ :key | userpasswordTextMorph textMorph acceptContents ] .
    	userpasswordTextMorph borderWidth: 1; borderColor: Color skyBlue; morphWidth: 300. 
    	userpasswordTextMorph morphHeight: 10.! !


!LibrosClientLoginWindow methodsFor: 'private' stamp: 'G.L.S 7/1/2021 18:49:18'!
defaultExtent

	^ 1035@485! !

!LibrosClientLoginWindow methodsFor: 'private' stamp: 'G.L.S 7/3/2021 20:38:48'!
setButtonsWidth.
	
	createCartButton layoutSpec proportionalWidth: 0.3.
	listPurchasesButton layoutSpec proportionalWidth: 0.3.! !


!LibrosClientLoginWindow methodsFor: 'window closing' stamp: 'G.L.S 7/7/2021 23:23:43'!
closeWindow
	
	Preferences dismissAllOnOptionClose ifTrue:
		[Sensor rawMacOptionKeyPressed ifTrue:
			[^ self world closeUnchangedWindows]].
	self delete.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LibrosClientLoginWindow class' category: 'Ejercicio-Libros'!
LibrosClientLoginWindow class
	instanceVariableNames: ''!

!LibrosClientLoginWindow class methodsFor: 'as yet unclassified' stamp: 'G.L.S 7/1/2021 18:47:35'!
open
	
	^self new initializeWith: 'Ejercicio Libros Client Window'.! !


!classDefinition: #LibrosClientPurchasesWindow category: 'Ejercicio-Libros'!
Panel subclass: #LibrosClientPurchasesWindow
	instanceVariableNames: 'leftLayout rightLayout purchasesList totalPriceLabel logoutButton createCartButton'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!LibrosClientPurchasesWindow methodsFor: 'private' stamp: 'G.L.S 7/3/2021 21:10:35'!
defaultExtent
	
	^1035@485.! !

!LibrosClientPurchasesWindow methodsFor: 'private' stamp: 'G.L.S 7/7/2021 23:46:56'!
updateDisplay
	
	purchasesList updateList.
	purchasesList setSelectionIndex: 0.
	totalPriceLabel contents: 'Total $', self model totalAmount.! !


!LibrosClientPurchasesWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 20:54:08'!
addCreateCartButton

	rightLayout addMorph: createCartButton.
	
	! !

!LibrosClientPurchasesWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 20:53:52'!
addLogoutButton
	
	rightLayout addMorph: logoutButton.
	
	! !

!LibrosClientPurchasesWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 21:07:33'!
addPurchaseList
	
	leftLayout addMorph: (LabelMorph contents: 'Historial de compras').
	leftLayout addMorph: purchasesList.
	
	
	! !

!LibrosClientPurchasesWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 20:53:10'!
addTotalPriceLabel
	
	leftLayout addMorph: totalPriceLabel.
	
	! !

!LibrosClientPurchasesWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 21:45:16'!
buildMorphicWindow
	
	self layoutMorph beRow.
	
	leftLayout := LayoutMorph newColumn.
	leftLayout axisEdgeWeight: 0.5.
	
	rightLayout := LayoutMorph newColumn.
	rightLayout  axisEdgeWeight: 0.5.
	
	self createPurchasesList.
	self createTotalPriceLabel.
	self createLogoutButton.
	self createCreateCartButton.
	
	self addPurchaseList.
	self addTotalPriceLabel.
	self addLogoutButton.
	self addCreateCartButton.
	
	self layoutMorph addMorph: leftLayout.
	self layoutMorph addMorph: rightLayout.
	! !

!LibrosClientPurchasesWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 21:45:53'!
createCreateCartButton
	
	createCartButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #tryToCreateCartWithUserCredentials
								label: 'Create Cart'.
								
	createCartButton layoutSpec proportionalWidth: 0.5.! !

!LibrosClientPurchasesWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 21:45:41'!
createLogoutButton

	logoutButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #logout
								label: 'Logout'.
	
	logoutButton layoutSpec proportionalWidth: 0.5.

	
	
	! !

!LibrosClientPurchasesWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 21:37:42'!
createPurchasesList

	purchasesList := PluggableListMorph model: self model listGetter: #getPurchases indexGetter: #purchasesListIndex indexSetter: #purchasesListIndex:.
	purchasesList  borderColor: Color skyBlue; borderWidth: 1; morphWidth: 300.
	
	purchasesList layoutSpec proportionalHeight: 0.85.
	
	! !

!LibrosClientPurchasesWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 20:35:48'!
createTotalPriceLabel

	totalPriceLabel := LabelMorph contents: ''.
	
	! !


!LibrosClientPurchasesWindow methodsFor: 'windows' stamp: 'G.L.S 7/8/2021 00:39:36'!
showCartWindow

	LibrosClientCartWindow withModel: self model.
	self closeWindow.! !


!LibrosClientPurchasesWindow methodsFor: 'initialization' stamp: 'G.L.S 7/8/2021 00:38:39'!
initializeWith: aModel

	self titleMorph showButtonsNamed: #( close collapse ).
	self model: aModel.
	self setLabel: 'Compras anteriores'.
	self morphExtent: (self defaultExtent).
	self buildMorphicWindow.
	self openInWorld.
	
	self model when: #logout send: #returnToLogin to: self.
	self model when: #successfullyCreatedCart send: #showCartWindow to: self.
	
	self updateDisplay.! !


!LibrosClientPurchasesWindow methodsFor: 'window closing' stamp: 'G.L.S 7/8/2021 00:36:53'!
closeWindow
	
	Preferences dismissAllOnOptionClose ifTrue:
		[Sensor rawMacOptionKeyPressed ifTrue:
			[^ self world closeUnchangedWindows]].
	self delete.

	! !

!LibrosClientPurchasesWindow methodsFor: 'window closing' stamp: 'G.L.S 7/8/2021 00:36:43'!
returnToLogin
	
	LibrosClientLoginWindow open.
	
	self closeWindow.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LibrosClientPurchasesWindow class' category: 'Ejercicio-Libros'!
LibrosClientPurchasesWindow class
	instanceVariableNames: ''!

!LibrosClientPurchasesWindow class methodsFor: 'as yet unclassified' stamp: 'G.L.S 7/3/2021 21:09:46'!
withModel: aModel
	
	^self new initializeWith: aModel.! !


!classDefinition: #LibrosClientTicketWindow category: 'Ejercicio-Libros'!
Panel subclass: #LibrosClientTicketWindow
	instanceVariableNames: 'purchasesList totalPriceLabel createCartButton logoutButton listPurchasesButton'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 23:54:13'!
addCreateCartButton
	
	self layoutMorph addMorph: createCartButton.
	! !

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 23:54:44'!
addListPurchasesButton

	self layoutMorph addMorph: listPurchasesButton.
	
	! !

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 23:55:06'!
addLogoutButton

	self layoutMorph addMorph: logoutButton.
	! !

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 23:53:09'!
addPurchaseList
	
	self layoutMorph addMorph: (LabelMorph contents: 'Resumen del carrito').
	self layoutMorph addMorph: purchasesList.! !

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 23:53:40'!
addTotalPriceLabel

	self layoutMorph addMorph: totalPriceLabel.
	! !

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/8/2021 00:26:36'!
buildMorphicWindow
	
	self layoutMorph beColumn.
	self layoutMorph axisEdgeWeight: 0.5.
	
	self createPurchasesList.
	self createTotalPriceLabel.
	self createCreateCartButton.
	self createListPurchasesButton.
	self createLogoutButton.
	
	self addPurchaseList.
	self addTotalPriceLabel.
	self addCreateCartButton.
	self addListPurchasesButton.
	self addLogoutButton.
	! !

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 23:48:49'!
createCreateCartButton
	
	createCartButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #tryToCreateCartWithUserCredentials
								label: 'Create Cart'.
								
	createCartButton layoutSpec proportionalWidth: 0.5.! !

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/8/2021 00:28:51'!
createListPurchasesButton.

	listPurchasesButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #tryToListPurchasesWithUserCredentials
								label: 'List Purchases'.
	
	listPurchasesButton layoutSpec proportionalWidth: 0.5.! !

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 23:49:00'!
createLogoutButton

	logoutButton := PluggableButtonMorph model: self model 
								stateGetter: nil  
								action: #logout
								label: 'Logout'.
	
	logoutButton layoutSpec proportionalWidth: 0.5.

	
	
	! !

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/8/2021 00:27:19'!
createPurchasesList

	purchasesList := PluggableListMorph model: self model listGetter: #getPurchases indexGetter: #purchasesListIndex indexSetter: #purchasesListIndex:.
	purchasesList  borderColor: Color skyBlue; borderWidth: 1; morphWidth: 300.
	
	purchasesList layoutSpec proportionalHeight: 0.85.! !

!LibrosClientTicketWindow methodsFor: 'interface creation' stamp: 'G.L.S 7/7/2021 23:47:48'!
createTotalPriceLabel

	totalPriceLabel := LabelMorph contents: ''.
	
	! !


!LibrosClientTicketWindow methodsFor: 'initialization' stamp: 'G.L.S 7/7/2021 23:48:01'!
updateDisplay
	
	purchasesList updateList.
	purchasesList setSelectionIndex: 0.
	totalPriceLabel contents: 'Total $', self model totalAmount.! !

!LibrosClientTicketWindow methodsFor: 'initialization' stamp: 'G.L.S 7/8/2021 12:08:17'!
withModel: aModel

	self titleMorph showButtonsNamed: #( close collapse ).
	self model: aModel.
	self setLabel: 'Resumen de compra'.
	self morphExtent: (self defaultExtent).
	self buildMorphicWindow.
	self openInWorld.
	
	self model when: #logout send: #returnToLogin to: self.
	self model when: #successfullyCreatedCart send: #showCartWindow to: self.
	self model when: #successfullyListedPurchases send: #showPurchasesWindow to: self.
	
	self updateDisplay.! !


!LibrosClientTicketWindow methodsFor: 'private' stamp: 'G.L.S 7/7/2021 23:38:57'!
defaultExtent

	^ 1035@485! !


!LibrosClientTicketWindow methodsFor: 'window closing' stamp: 'G.L.S 7/8/2021 00:33:30'!
closeWindow
	
	Preferences dismissAllOnOptionClose ifTrue:
		[Sensor rawMacOptionKeyPressed ifTrue:
			[^ self world closeUnchangedWindows]].
	self delete.! !

!LibrosClientTicketWindow methodsFor: 'window closing' stamp: 'G.L.S 7/8/2021 12:08:50'!
returnToLogin
	
	LibrosClientLoginWindow open.
	self closeWindow.! !


!LibrosClientTicketWindow methodsFor: 'windows' stamp: 'G.L.S 7/8/2021 14:37:15'!
showCartWindow

	LibrosClientCartWindow withModel: self model.
	self closeWindow.! !

!LibrosClientTicketWindow methodsFor: 'windows' stamp: 'G.L.S 7/8/2021 14:37:36'!
showPurchasesWindow
	
	LibrosClientPurchasesWindow withModel: self model.
	self closeWindow.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LibrosClientTicketWindow class' category: 'Ejercicio-Libros'!
LibrosClientTicketWindow class
	instanceVariableNames: ''!

!LibrosClientTicketWindow class methodsFor: 'initialization' stamp: 'G.L.S 7/7/2021 23:57:12'!
withModel: aModel

	^self new withModel: aModel.! !


!classDefinition: #CartTest category: 'Ejercicio-Libros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'smalltalk80 designPatterns objectThinking emptyCatalog catalog1'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!CartTest methodsFor: 'testing' stamp: 'G.L.S 7/7/2021 16:10:47'!
setUp

	smalltalk80 := '9780201113723'.
	designPatterns := '9780201184624'.
	objectThinking := '9780735619654'.
	
	emptyCatalog := Dictionary new.
	
	catalog1 := StoreObjectFactory new createDefaultCatalog.! !

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

!CartTest methodsFor: 'testing' stamp: 'G.L.S 7/6/2021 19:15:15'!
test08CannotRemoveAnItemIfItIsNotInTheCart

	| carrito |
	carrito := Cart createNewWithCatalog: catalog1.
	
	self should: [
		carrito remove: smalltalk80.
		]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [
			:anError |
			self assert: anError messageText equals: Cart errorCannotRemoveAnItemNotInCart.
			].
	
	
	! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 7/6/2021 19:26:42'!
test09CannotRemoveMoreItemsThatTheOnesTheCartHas

	| carrito |
	carrito := Cart createNewWithCatalog: catalog1.
	carrito add: smalltalk80 amount: 20.
	
	self should: [
		carrito remove: smalltalk80 amount: 450.
		]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [
			:anError |
			self assert: anError messageText equals: Cart errorCannotRemoveMoreItemsThanWhatTheCartHas.
			].
	
	
	! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 7/6/2021 19:44:06'!
test10RemovingAnItemTakesItOutOfTheCart

	| carrito |
	carrito := Cart createNewWithCatalog: catalog1.
	carrito add: smalltalk80.
	carrito remove: smalltalk80.
	
	self deny: (carrito isBookInCart: smalltalk80).
	
	
	! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 7/6/2021 20:04:35'!
test11RemovingLessItemsThanWhatTheCartHasLeavesSomeInTheCart

	| carrito |
	carrito := Cart createNewWithCatalog: catalog1.
	carrito add: smalltalk80 amount: 10.
	carrito remove: smalltalk80.
	
	self assert: (carrito isBookInCart: smalltalk80).
	
	
	! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 7/6/2021 21:32:55'!
test12AddingItemMultipleTimesToTheCartCorrectlyChangesTheAmount

	| carrito huboError |
	
	huboError := #No.
	
	carrito := Cart createNewWithCatalog: catalog1.
	carrito add: smalltalk80.
	carrito add: smalltalk80.
	
	[carrito remove: smalltalk80 amount: 2.] 
		on: Error 
		do: [huboError := #Si]. 
	
	self deny: (carrito isBookInCart: smalltalk80).
	self assert: #No equals: huboError.
	
	
	! !

!CartTest methodsFor: 'testing' stamp: 'G.L.S 7/7/2021 16:06:29'!
test13ThePriceOfTheCartItemsIsEqualToTheQuantityOfEachOneOfThemTimesTheirPrice

	| carrito |
	
	carrito := Cart createNewWithCatalog: catalog1.
	carrito add: smalltalk80 amount: 20.
	carrito add: objectThinking amount: 3.
	
	self assert: 350 equals: carrito totalItemPrice.
	
	
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
	instanceVariableNames: 'smalltalk80 designPatterns objectThinking catalog1 emptyCatalog catalog2 donQuixote workingCreditCard expiredCreditCard sales stolenCreditCard merchantProcessor fakeCreditCard creditCardWithoutMoney listToAdd emptyListToAdd listToAdd2 storeFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!CashierTest methodsFor: 'testing' stamp: 'G.L.S 7/7/2021 16:09:54'!
setUp
	
	storeFactory := StoreObjectFactory new.
	
	sales := OrderedCollection new.
	
	smalltalk80 := '9780201113723'.
	designPatterns := '9780201184624'.
	objectThinking := '9780735619654'.
	donQuixote := '9781400132171'.
	
	emptyCatalog := storeFactory createEmptyCatalog.
	
	catalog1 := storeFactory createDefaultCatalog.
	
	catalog2 := storeFactory createSingleItemCatalog.
	
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


!classDefinition: #MockRestInterfaceTest category: 'Ejercicio-Libros'!
TestCase subclass: #MockRestInterfaceTest
	instanceVariableNames: 'mockInterface userData sales smalltalk80 designPatterns objectThinking donQuixote emptyCatalog catalog1 catalog2 workingCreditCard merchantProcessor timer storeFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/24/2021 15:19:09'!
test01CannotCreateCartWithTheWrongUserPassword

	| password usuario |
	
	usuario := 'pepe'.
	password := '1234'.
	
	self testFail: [mockInterface createCartForUser: usuario password: password] withErrorMessage: MockRestInterface errorWrongUserCredentials.! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/21/2021 16:22:46'!
test02CreateCartForAnExistingUserDoesNotFail

	| password usuario huboError |
	
	usuario := 'pepe'.
	password := '5678'.
	
	huboError := #No.
	
	[mockInterface createCartForUser: usuario password: password] 
		on: Error 
		do: [huboError := #Si].
		
	self assert: #No equals: huboError.! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/24/2021 15:19:38'!
test03CannotCreateCartForAUserThatDoesntExist

	| password usuarioNoExistente |
	
	usuarioNoExistente := 'Jorge'.
	password := '1234'.
		
	self testFail: [mockInterface createCartForUser: usuarioNoExistente password: password] withErrorMessage: MockRestInterface errorWrongUserCredentials.	! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/24/2021 15:20:49'!
test04CannotAddItemToAnUnexistentCart

	self testFail: [mockInterface add: 17 ofItem: smalltalk80 toCart: 0] withErrorMessage: MockRestInterface errorCartIdDoesNotExist.! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/21/2021 15:47:11'!
test05AddingItemsToCartWorksAsExpected

	| password usuario huboError cartId cartList |
	
	usuario := 'pepe'.
	password := '5678'.
	
	huboError := #No.
	
	cartId := mockInterface createCartForUser: usuario password: password.
	
	[mockInterface add: 17 ofItem: smalltalk80 toCart: cartId] 
		on: Error 
		do: [huboError := #Si].
	
	cartList := (mockInterface listCart: cartId).
	
	self assert: #No equals: huboError.
	self deny: (cartList) isEmpty.
	self assert: smalltalk80 equals: cartList first first.
	self assert: 17 equals: cartList first second.
	! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/21/2021 15:47:11'!
test06DifferentCartsCannotHaveTheSameId

	| password usuario cartId1 cartId2 password2 usuario2 |
	
	usuario := 'pepe'.
	password := '5678'.
	
	usuario2 := 'ramon'.
	password2 := '1234'.
	
	cartId1 := mockInterface createCartForUser: usuario password: password.
	cartId2 := mockInterface createCartForUser: usuario2 password: password2.
	
	self deny: (cartId1 = cartId2).! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/24/2021 15:23:55'!
test07CannotListCartAnUnexistentCart

	self testFail: [mockInterface listCart: 0] withErrorMessage: MockRestInterface errorCartIdDoesNotExist.! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/24/2021 15:24:35'!
test08CannotListPurchasesWithAnUserThatDoesntExist

	| password usuarioNoExistente |
	
	usuarioNoExistente := 'Jorge'.
	password := '1234'.
	
	self testFail: [mockInterface listPurchasesForUser: usuarioNoExistente withPassword: password] withErrorMessage: MockRestInterface errorWrongUserCredentials.
			! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/28/2021 21:25:34'!
test09CannotCheckOutWithACartThatDoesNotExist

		
	self testFail: [mockInterface checkOutCart: 0 withCreditCard: '' withExpirationDate: '' withOwner: '']  		withErrorMessage: MockRestInterface errorCartIdDoesNotExist.! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/28/2021 21:28:27'!
test10SuccessfulCheckoutAltersUserListPurchase
	
	| password usuario cartId |
	
	usuario := 'pepe'.
	password := '5678'.
	
	cartId := mockInterface createCartForUser: usuario password: password.
	
	mockInterface add: 17 ofItem: smalltalk80 toCart: cartId.
	
	mockInterface checkOutCart: cartId 
				withCreditCard: '0000000000000000' 
				withExpirationDate: FixedGregorianDate tomorrow 
				withOwner: 'Marco'.
	
	self assert: ((mockInterface listPurchasesForUser: usuario withPassword: password) at: smalltalk80) = 17.
	self assert: ((mockInterface listPurchasesForUser: usuario withPassword: password) at: 'totalBooks') = 170.
	
	cartId := mockInterface createCartForUser: usuario password: password.
	
	mockInterface add: 17 ofItem: smalltalk80 toCart: cartId.
	
	mockInterface checkOutCart: cartId 
				withCreditCard: '0000000000000000' 
				withExpirationDate: FixedGregorianDate tomorrow 
				withOwner: 'Marco'.
	
	self assert: ((mockInterface listPurchasesForUser: usuario withPassword: password) at: smalltalk80) = 34.
	self assert: ((mockInterface listPurchasesForUser: usuario withPassword: password) at: 'totalBooks') = 340.! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 7/7/2021 18:14:40'!
test11CannotUseACartAfterItExpired

	| password usuario cartId |
	
	usuario := 'pepe'.
	password := '5678'.
	
	cartId := mockInterface createCartForUser: usuario password: password.
	
	mockInterface add: 17 ofItem: smalltalk80 toCart: cartId.
	
	mockInterface listCart: cartId.
	
	timer passTime: 35.
	
	self testFail: [mockInterface add: 17 ofItem: smalltalk80 toCart: cartId] withErrorMessage: MockRestInterface errorCartExpired.
	
	self testFail: [mockInterface remove: 17 ofItem: smalltalk80 fromCart: cartId] withErrorMessage: MockRestInterface errorCartExpired.
	
	self testFail: [mockInterface listCart: cartId]  withErrorMessage: MockRestInterface errorCartExpired.
	
	self testFail: [mockInterface checkOutCart: cartId 
				withCreditCard: '0000000000000000' 
				withExpirationDate: FixedGregorianDate tomorrow 
				withOwner: 'Marco'] 
		withErrorMessage: MockRestInterface errorCartExpired.
	
! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 7/8/2021 00:12:59'!
test12SuccesfulCheckoutsProduceDifferentTransactionIds
	
	| password usuario cartId transactionId1 transactionId2 |
	
	usuario := 'pepe'.
	password := '5678'.
	
	cartId := mockInterface createCartForUser: usuario password: password.
	
	mockInterface add: 17 ofItem: smalltalk80 toCart: cartId.
	
	transactionId1 := (mockInterface checkOutCart: cartId 
					withCreditCard: '0000000000000000' 
					withExpirationDate: FixedGregorianDate tomorrow 
					withOwner: 'Marco') at: 'id'.
	
	cartId := mockInterface createCartForUser: usuario password: password.
	
	mockInterface add: 17 ofItem: smalltalk80 toCart: cartId.
	
	transactionId2 := (mockInterface checkOutCart: cartId 
					withCreditCard: '0000000000000000' 
					withExpirationDate: FixedGregorianDate tomorrow 
					withOwner: 'Marco') at: 'id'.
	
	self deny: (transactionId1 = transactionId2).! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/29/2021 19:50:24'!
test13CannotCheckoutAPreviouslyCheckoutedCart
	
	| password usuario cartId |
	
	usuario := 'pepe'.
	password := '5678'.
	
	cartId := mockInterface createCartForUser: usuario password: password.
	
	mockInterface add: 17 ofItem: smalltalk80 toCart: cartId.
	
	mockInterface checkOutCart: cartId 
				withCreditCard: '0000000000000000' 
				withExpirationDate: FixedGregorianDate tomorrow 
				withOwner: 'Marco'.
				
	self testFail: [
			mockInterface checkOutCart: cartId 
				withCreditCard: '0000000000000000' 
				withExpirationDate: FixedGregorianDate tomorrow 
				withOwner: 'Marco'.
				] 
		withErrorMessage: MockRestInterface errorCartIdDoesNotExist.! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 7/7/2021 18:05:21'!
test14CannotRemoveFromUnexistentCart

	self testFail: [mockInterface remove: 17 ofItem: smalltalk80 fromCart: 0] withErrorMessage: MockRestInterface errorCartIdDoesNotExist.! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 7/7/2021 18:13:38'!
test15RemovingItemsFromCartWorksAsExpected

	| password usuario huboError cartId cartList |
	
	usuario := 'pepe'.
	password := '5678'.
	
	huboError := #No.
	
	cartId := mockInterface createCartForUser: usuario password: password.
	
	mockInterface add: 17 ofItem: smalltalk80 toCart: cartId.
	
	[mockInterface remove: 17 ofItem: smalltalk80 fromCart: cartId.] 
		on: Error 
		do: [huboError := #Si].
	
	cartList := (mockInterface listCart: cartId).
	
	self assert: #No equals: huboError.
	self assert: (cartList) isEmpty.
	! !

!MockRestInterfaceTest methodsFor: 'testing' stamp: 'G.L.S 6/24/2021 15:18:27'!
testFail: aBlock withErrorMessage: anErrorMessage
	
	self should: aBlock 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [
			:anError |
			self assert: anError messageText equals: anErrorMessage.
			].! !


!MockRestInterfaceTest methodsFor: 'setUp/tearDown' stamp: 'G.L.S 7/7/2021 19:34:17'!
setUp
	
	storeFactory := StoreObjectFactory new.
	
	smalltalk80 := '9780201113723'.
	designPatterns := '9780201184624'.
	objectThinking := '9780735619654'.
	donQuixote := '9781400132171'.
	
	sales := OrderedCollection new.
	
	emptyCatalog := Dictionary new.
	
	catalog1 := storeFactory createDefaultCatalog.
	
	catalog2 := storeFactory createSingleItemCatalog.
	
	userData := Dictionary new.
	userData add: 'pepe' -> '5678'.
	userData add: 'ramon' -> '1234'.
	
	timer := (MockTimer new).
	
	workingCreditCard := CreditCard forOwner: 'Marco' withNumber: '0000000000000000' withExpirationDate: FixedGregorianDate tomorrow.
	
	merchantProcessor := MockMerchantProcesor new.
	merchantProcessor registerCard: workingCreditCard withBalance: 1000.
	
	mockInterface := MockRestInterface createFor: userData withCatalog: catalog1 withTimer: timer withSalesBook: sales withMerchantProcesor: merchantProcessor.
	! !


!classDefinition: #Cart category: 'Ejercicio-Libros'!
Object subclass: #Cart
	instanceVariableNames: 'cartItems catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/9/2021 18:11:29'!
add: aBook 
	self add: aBook amount: 1.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 7/6/2021 22:02:31'!
add: aBook amount: anAmount 
	
	
	self assertBookIsAllowed: aBook.
	self assertAmountIsValid: anAmount.
	
	(self isBookInCart: aBook)
		ifTrue: [self increaseAmountOf: aBook by: anAmount]
		ifFalse: [self addNewBook: aBook amount: anAmount].! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 7/6/2021 22:02:06'!
addNewBook: aBook amount: anAmount
	
	| tuplaLibroCant |
	
	tuplaLibroCant := OrderedCollection new.
	tuplaLibroCant add: aBook.
	tuplaLibroCant add: anAmount.
	
	cartItems add: tuplaLibroCant.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/10/2021 13:49:35'!
assertAmountIsValid: anAmount.

	(anAmount isInteger) ifFalse: [self error: self class errorAmountNotInteger].
	(anAmount < 0) ifTrue: [self error: self class errorAmountNegative].
	(anAmount = 0) ifTrue: [self error: self class errorAmountZero].! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 7/6/2021 19:20:14'!
assertBookInCart: aBook
	
	(self isBookInCart: aBook) ifFalse: [self error: self class errorCannotRemoveAnItemNotInCart].! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:00:17'!
assertBookIsAllowed: aBook

	(catalog keys includes: aBook) ifFalse:[self error: self class errorBookNotInAllowedList.].! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 7/6/2021 19:45:17'!
assertCartCanRemove: anAmount ofItem: aBook

	((self cartItemForBook: aBook) second >= anAmount) ifFalse: [self error: self class errorCannotRemoveMoreItemsThanWhatTheCartHas].! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 7/6/2021 19:45:39'!
cartItemForBook: aBook

	cartItems do: [:aCartItem | 
		(aCartItem includes: aBook) ifTrue:[^aCartItem].
		].
	
	^nil.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:08:23'!
first
	^cartItems first.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:00:17'!
hasCatalog: aCatalog
	^catalog = aCatalog.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 7/6/2021 22:03:35'!
increaseAmountOf: aBook by: anAmount

	| itemToIncrease |
	
	itemToIncrease := self cartItemForBook: aBook.
	
	itemToIncrease at:2 put: (itemToIncrease second + anAmount).! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:08:24'!
isEmpty
	^cartItems isEmpty.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 7/6/2021 19:16:47'!
remove: aBook
	
	self remove: aBook amount: 1.
	! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 7/6/2021 20:08:02'!
remove: aBook amount: anAmount

	| itemToRemove |
	self assertBookInCart: aBook.
	self assertCartCanRemove: anAmount ofItem: aBook.
	
	itemToRemove := self cartItemForBook: aBook.
	
	(itemToRemove second - anAmount) = 0 
		ifTrue: [
			cartItems remove: itemToRemove.
			]
		ifFalse:[
			itemToRemove at:2 put: (itemToRemove second - anAmount).
			].! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:08:23'!
second
	^cartItems second.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 6/14/2021 19:08:23'!
size
	^cartItems size.! !

!Cart methodsFor: 'operations' stamp: 'G.L.S 7/7/2021 16:07:11'!
totalItemPrice
	
	^cartItems sum: [:bookAmountTuple | ((catalog at: bookAmountTuple first) at:'precio') * bookAmountTuple second].! !


!Cart methodsFor: 'initialization' stamp: 'G.L.S 6/14/2021 19:08:24'!
initializeWith: anOrderedCollection
	catalog := anOrderedCollection.
	cartItems := OrderedCollection new.! !


!Cart methodsFor: 'private' stamp: 'G.L.S 7/6/2021 19:21:54'!
isBookInCart: aBook
	
	| found |
	found := false.
	
	cartItems do: [:aCartItem | 
		(aCartItem includes: aBook) ifTrue: [found := true].
		].
	
	^found.! !

!Cart methodsFor: 'private' stamp: 'G.L.S 6/21/2021 15:46:50'!
itemListFor: aMockRestInterface
	^aMockRestInterface listCartItemsFor: cartItems.! !

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

!Cart class methodsFor: 'errors' stamp: 'G.L.S 7/8/2021 16:36:19'!
errorCannotRemoveAnItemNotInCart
	^'Error - No se puede remover ese item, no esta dentro del carrito'.! !

!Cart class methodsFor: 'errors' stamp: 'G.L.S 7/6/2021 19:27:26'!
errorCannotRemoveMoreItemsThanWhatTheCartHas
	^'Error - No se puede remover una cantidad mayor de items de las que tiene el carrito'.! !


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

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 7/8/2021 15:50:57'!
errorCannotCheckoutACartWithADifferentCatalog
	^'Error - No se puede hacer checkout de un carrito con un catalogo diferente'.! !

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 7/8/2021 15:50:52'!
errorCannotCheckoutEmptyCart
	^'Error - No se puede hacer checkout de un carrito vacio'.! !

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 7/8/2021 15:51:01'!
errorCardDoesNotHaveEnoughBalance

	^'Error - La tarjeta de credito no tiene suficiente saldo'.! !

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 7/8/2021 15:51:06'!
errorExpiredCard
	^'Error - No se puede hacer checkout con una tarjeta de credito vacía'.! !

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 6/16/2021 16:18:52'!
errorNotARegisteredCard
	^'Error - La tarjeta utilizada no se encuentra registrada'.! !

!Cashier class methodsFor: 'errors' stamp: 'G.L.S 7/8/2021 15:51:14'!
errorStolenCard
	^'Error - No se puede realizar una transaccion con una tarjeta robada'.! !


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


!CreditCard methodsFor: 'private' stamp: 'G.L.S 6/21/2021 18:49:48'!
= aCreditCard
	
	^ aCreditCard isNumber: creditCardNumber.! !

!CreditCard methodsFor: 'private' stamp: 'G.L.S 6/14/2021 21:25:06'!
assertNameNotEmpty: anOwner
	
	anOwner withBlanksTrimmed isEmpty ifTrue: [self error: self class errorOwnerEmpty].! !

!CreditCard methodsFor: 'private' stamp: 'G.L.S 6/21/2021 18:58:58'!
isNumber: aCreditCardNumber.
	
	^ aCreditCardNumber = creditCardNumber.! !


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


!classDefinition: #LibrosClientModel category: 'Ejercicio-Libros'!
Object subclass: #LibrosClientModel
	instanceVariableNames: 'username userpassword restInterface cartId purchases storeItemList cartItemList storeItemListIndex cartItemListIndex catalog itemAmount storeFactory totalAmount purchasesListIndex transactionId errorMessage'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!LibrosClientModel methodsFor: 'initialization' stamp: 'G.L.S 7/8/2021 15:04:37'!
initialize
	
	username := ''.
	userpassword := ''.
	errorMessage := ''.
	
	restInterface := LibrosRestInterface new.
	
	storeFactory := StoreObjectFactory new.
	
	self getCatalog.
	
	self prepareStoreItemList.
	
	cartItemList := OrderedCollection new.
	
	storeItemListIndex := 0.
	cartItemListIndex := 0.
	
	itemAmount := ''.
	totalAmount := ''.
	
	purchases := OrderedCollection new.
	purchasesListIndex := 0.
	! !


!LibrosClientModel methodsFor: 'private' stamp: 'G.L.S 7/7/2021 17:35:44'!
decodeCartItemsList: listToDecode
	
	| decodedList listToDecodeCopy |
	
	listToDecodeCopy := listToDecode copyFrom: 3 to: listToDecode size. 
	decodedList  := OrderedCollection new.
	
	[listToDecodeCopy = ''] whileFalse: [ | tempString isbn |
		tempString _ ''.
		isbn _ listToDecodeCopy copyUpTo: $|.
		listToDecodeCopy _ listToDecodeCopy copyAfter: $|.
		tempString _ isbn, ' - ', ((catalog at: isbn) at: 'nombre'), ' - ', listToDecodeCopy copyUpTo: $|.
		listToDecodeCopy _ listToDecodeCopy copyAfter: $|.
		
		decodedList add: tempString.
	].

	^decodedList.
	
	! !

!LibrosClientModel methodsFor: 'private' stamp: 'G.L.S 7/7/2021 23:12:30'!
decodePurchaseList: listToDecode

	| decodedList listToDecodeCopy |
	
	listToDecodeCopy := listToDecode copyFrom: 3 to: listToDecode size - 1.
	decodedList  := OrderedCollection new.
	
	[listToDecodeCopy = ''] whileFalse: [ | tempString isbn |
		tempString _ ''.
		isbn _ ''.
		[isbn = '' and: [(listToDecodeCopy = '') not]] whileTrue: [
			isbn _ listToDecodeCopy copyUpTo: $|.
			listToDecodeCopy _ listToDecodeCopy copyAfter: $|.
			].
		
		(isbn = 'totalBooks') 
			ifTrue:[
					tempString _ listToDecodeCopy copyUpTo: $|.
					listToDecodeCopy _ listToDecodeCopy copyAfter: $|.
				]
			ifFalse:[
					tempString _ isbn, ' - ', ((catalog at: isbn) at: 'nombre'), ' - ', listToDecodeCopy copyUpTo: $|.
					listToDecodeCopy _ listToDecodeCopy copyAfter: $|.
				].
		
		decodedList add: tempString.
	].

	^decodedList.
	
	
	
	! !

!LibrosClientModel methodsFor: 'private' stamp: 'G.L.S 7/8/2021 00:20:39'!
decodeTicketCartList: listToDecode

	| decodedList listToDecodeCopy |
	
	listToDecodeCopy := listToDecode copyFrom: 1 to: listToDecode size.
	decodedList  := OrderedCollection new.
	
	[listToDecodeCopy = ''] whileFalse: [ | tempString isbn |
		tempString _ ''.
		isbn _ ''.
		[isbn = '' and: [(listToDecodeCopy = '') not]] whileTrue: [
			isbn _ listToDecodeCopy copyUpTo: $|.
			listToDecodeCopy _ listToDecodeCopy copyAfter: $|.
			].
		
		(isbn = 'total') 
			ifTrue:[
					tempString _ listToDecodeCopy copyUpTo: $|.
					listToDecodeCopy _ listToDecodeCopy copyAfter: $|.
				]
			ifFalse:[
					tempString _ isbn, ' - ', ((catalog at: isbn) at: 'nombre'), ' - ', listToDecodeCopy copyUpTo: $|.
					listToDecodeCopy _ listToDecodeCopy copyAfter: $|.
				].
		
		decodedList add: tempString.
	].

	^decodedList.! !

!LibrosClientModel methodsFor: 'private' stamp: 'G.L.S 7/8/2021 15:05:58'!
errorMessage
	
	^errorMessage.! !

!LibrosClientModel methodsFor: 'private' stamp: 'G.L.S 7/7/2021 20:00:05'!
obtainCatalog
	
	! !

!LibrosClientModel methodsFor: 'private' stamp: 'G.L.S 7/7/2021 16:12:47'!
prepareStoreItemList
	
	storeItemList := OrderedCollection new.
	
	catalog keysDo: [:key |
		storeItemList add: key, ' - ', ((catalog at: key) at:'nombre').
		].
! !


!LibrosClientModel methodsFor: 'setters - login' stamp: 'G.L.S 7/3/2021 20:17:05'!
usernameText: aUserName.

	username := aUserName.
	
	^true.! !

!LibrosClientModel methodsFor: 'setters - login' stamp: 'G.L.S 7/3/2021 20:19:09'!
userpasswordText: aUserPassword.

	userpassword := aUserPassword.
	
	^true.! !


!LibrosClientModel methodsFor: 'setters - cart' stamp: 'G.L.S 7/7/2021 21:39:45'!
cartItemListIndex: anIndex
	
	cartItemListIndex := anIndex.! !

!LibrosClientModel methodsFor: 'setters - cart' stamp: 'G.L.S 7/6/2021 18:46:44'!
itemAmountText: anAmountOfItemsString

	itemAmount := anAmountOfItemsString.
	
	^true.! !

!LibrosClientModel methodsFor: 'setters - cart' stamp: 'G.L.S 7/7/2021 21:39:40'!
storeItemListIndex: anIndex

	storeItemListIndex := anIndex.! !


!LibrosClientModel methodsFor: 'getters - login' stamp: 'G.L.S 7/3/2021 16:56:36'!
usernameText
	
	^username.! !

!LibrosClientModel methodsFor: 'getters - login' stamp: 'G.L.S 7/3/2021 17:01:29'!
userpasswordText
	
	^userpassword.! !


!LibrosClientModel methodsFor: 'getters - cart' stamp: 'G.L.S 7/6/2021 16:47:14'!
cartItemListIndex
	^cartItemListIndex.! !

!LibrosClientModel methodsFor: 'getters - cart' stamp: 'G.L.S 7/6/2021 16:46:24'!
getCartItemList
	^cartItemList.! !

!LibrosClientModel methodsFor: 'getters - cart' stamp: 'G.L.S 7/6/2021 16:41:49'!
getStoreItemList
	^storeItemList.
	! !

!LibrosClientModel methodsFor: 'getters - cart' stamp: 'G.L.S 7/6/2021 18:32:38'!
itemAmountText
	
	^itemAmount.! !

!LibrosClientModel methodsFor: 'getters - cart' stamp: 'G.L.S 7/6/2021 16:42:44'!
storeItemListIndex
	^storeItemListIndex! !


!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/8/2021 16:16:05'!
addSelectedItemToCart
	
	| amount isbn huboError |
	
	huboError := false.
	
	[isbn := ((storeItemList at: storeItemListIndex) copyUpTo: $-) withoutSeparators.]
	on: Error
	do: [	:error |
		errorMessage := 'Error - No ha seleccionado un libro'.
		huboError := true.
		"self triggerEvent: #isbnCalculationError with: self"
		self triggerEvent: #errorHappened with: self.].
	
	[amount := (itemAmount = '') ifTrue:[1] ifFalse:[itemAmount asNumber].]
	on: Error
	do: [	:error |
		errorMessage := 'Error - La cantidad de libros no es un numero'.
		huboError := true.
		"self triggerEvent: #amountCalculationError with: self."
		self triggerEvent: #errorHappened with: self].
	
	huboError ifFalse: [
	[restInterface sendAddToCartRequestWithCart: cartId bookISBN: isbn amount: amount]
	on: Error - MessageNotUnderstood
	do: [:error |
		self registerErrorMessage: error.
		"self triggerEvent: #addItemToCartFailed with: self."
		self triggerEvent: #errorHappened with: self.
		^self].
	].
	
	self triggerEvent: #itemAddedToCart with: self.! !

!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/8/2021 16:46:05'!
checkoutCart
	
	| listToDecode |
	
	[listToDecode := restInterface sendCheckOutRequestFor: cartId asString
							creditCardNumber: storeFactory createDefaultCreditCardNumber
							creditCardExpiration: storeFactory createDefaultCreditCardExpirationDate 
							creditCardOwner: storeFactory createDefaultCreditCardOwner]
	on: Error - MessageNotUnderstood
	do: [ :error | 
		self registerErrorMessage: error.
		self triggerEvent: #errorHappened with: self.
		^self].
	
	listToDecode := 	listToDecode copyFrom: 3 to: listToDecode size - 1.
	
	transactionId := listToDecode copyUpTo: $|.
	
	listToDecode := listToDecode copyAfter: $|.
	
	listToDecode := self decodeTicketCartList: listToDecode.
	
	purchases := listToDecode copyFrom: 1 to: listToDecode size - 1.
	
	totalAmount  := listToDecode at: listToDecode size.
	
	self triggerEvent: #checkoutSuccessful with: self.! !

!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/7/2021 20:12:24'!
getCatalog
	
	[catalog := restInterface sendGetCatalog]
	on: Error - MessageNotUnderstood
	do: [self error: self class errorCatalogCouldNotBeDownloaded].
	
	! !

!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/8/2021 16:16:24'!
listCart

	| listToDecode |
	
	[listToDecode := restInterface sendListCartFor: cartId]
	on: Error - MessageNotUnderstood
	do: [ :error |
		self registerErrorMessage: error.
		"self triggerEvent: #listCartFailed with: self."
		self triggerEvent: #errorHappened with: self.
		^self].
	
	cartItemList := self decodeCartItemsList: listToDecode.
	
	! !

!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/7/2021 23:16:01'!
logout
	self triggerEvent: #logout with: self.! !

!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/8/2021 15:45:00'!
registerErrorMessage: anError
	
	| messageToDecode |
	
	messageToDecode := anError messageText copyAfter: $#.
	errorMessage := messageToDecode copyUpTo: $#.
	
	! !

!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/8/2021 16:22:49'!
removeSelectedItemFromCart
	
	| amount isbn huboError |
	
	huboError := false.
	
	[isbn := ((cartItemList at: cartItemListIndex) copyUpTo: $-) withoutSeparators.]
	on: Error
	do: [	:error |
		errorMessage := 'Error - No ha seleccionado un libro del carrito'.
		self triggerEvent: #errorHappened with: self].
	
	[amount := (itemAmount = '') ifTrue:[1] ifFalse:[itemAmount asNumber].]
	on: Error
	do: [	:error |
		errorMessage := 'Error - La cantidad de libros no es un numero'.
		self triggerEvent: #errorHappened with: self].
	
	huboError ifFalse: [
	[restInterface sendRemoveFromCartRequestWithCart: cartId bookISBN: isbn amount: amount]
	on: Error - MessageNotUnderstood
	do: [	:error |
		self registerErrorMessage: error.
		self triggerEvent: #errorHappened with: self.
		^self]
	].
	
	self triggerEvent: #itemRemovedFromCart with: self.! !

!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/7/2021 21:25:16'!
totalAmount

	^totalAmount.
	! !

!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/8/2021 16:18:44'!
tryToCreateCartWithUserCredentials
	
	[cartId := restInterface sendCreateCartRequestFor: username withPassword: userpassword]
	on: Error
	do: [	:error | 
		self registerErrorMessage: error.
		"self triggerEvent: #userCredentialsFailed with: self."
		self triggerEvent: #errorHappened with: self.
		^self].
	
	self triggerEvent: #successfullyCreatedCart with: self.
	
	! !

!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/8/2021 16:18:38'!
tryToListPurchasesWithUserCredentials
	
	| listToDecode |
	
	[listToDecode := restInterface sendListPurchasesRequestFor: username withPassword: userpassword]
	on: Error
	do: [ :error |
		self registerErrorMessage: error.
		"self triggerEvent: #userCredentialsFailed with: self."
		self triggerEvent: #errorHappened with: self.
		^self].
	
	listToDecode := self decodePurchaseList: listToDecode.
	
	purchases := listToDecode copyFrom: 1 to: listToDecode size - 1.
	
	self updateTotalAmount: (listToDecode at: listToDecode size).
	
	self triggerEvent: #successfullyListedPurchases with: self.
	
	! !

!LibrosClientModel methodsFor: 'requests' stamp: 'G.L.S 7/7/2021 21:24:12'!
updateTotalAmount: aTotalString

	totalAmount := aTotalString.
	
	! !


!LibrosClientModel methodsFor: 'getters - pricelist' stamp: 'G.L.S 7/7/2021 21:37:00'!
getPurchases
	^purchases.! !

!LibrosClientModel methodsFor: 'getters - pricelist' stamp: 'G.L.S 7/7/2021 21:39:03'!
purchasesListIndex
	
	^purchasesListIndex.
	! !

!LibrosClientModel methodsFor: 'getters - pricelist' stamp: 'G.L.S 7/7/2021 21:39:31'!
purchasesListIndex: anIndex
	
	purchasesListIndex := anIndex.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LibrosClientModel class' category: 'Ejercicio-Libros'!
LibrosClientModel class
	instanceVariableNames: ''!

!LibrosClientModel class methodsFor: 'errors' stamp: 'G.L.S 7/7/2021 20:12:59'!
errorCatalogCouldNotBeDownloaded
	^'Error - No se pudo conseguir el catalogo'.! !


!classDefinition: #LibrosRestInterface category: 'Ejercicio-Libros'!
Object subclass: #LibrosRestInterface
	instanceVariableNames: 'port'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!LibrosRestInterface methodsFor: 'private' stamp: 'G.L.S 7/3/2021 18:52:36'!
correctlyEncodeSpacesForUrlRequestParameter: aParameter
	
	^ aParameter copyReplaceAll: ' ' with: '%20'.! !


!LibrosRestInterface methodsFor: 'url' stamp: 'G.L.S 7/3/2021 18:51:34'!
url
	
	^'http://localhost:', self port asString! !


!LibrosRestInterface methodsFor: 'port' stamp: 'G.L.S 7/3/2021 18:51:55'!
port

	^port ifNil: [port:=8080].! !


!LibrosRestInterface methodsFor: 'requests' stamp: 'G.L.S 7/7/2021 16:43:07'!
sendAddToCartRequestWithCart: aCartId bookISBN: aISBN amount: anAmount 
	
	| fieldsDict resp |
	fieldsDict := Dictionary new.
	fieldsDict at: 'cartId' put: aCartId.
	fieldsDict at: 'bookIsbn' put: aISBN.
	fieldsDict at: 'bookQuantity' put: anAmount.
	
	resp := WebClient htmlSubmit: (self url, '/addToCart') fields: fieldsDict.
	
	resp isSuccess ifFalse: [^self error: resp content].
	! !

!LibrosRestInterface methodsFor: 'requests' stamp: 'G.L.S 7/8/2021 15:22:21'!
sendCheckOutRequestFor: aCartId creditCardNumber: aCreditCardNumber creditCardExpiration: aCreditCardExpirationDate creditCardOwner: aCreditCardOwner

	| fieldsDict resp |
	fieldsDict := Dictionary new.
	fieldsDict at: 'cartId' put: aCartId.
	fieldsDict at: 'ccn' put: aCreditCardNumber.
	fieldsDict at: 'cced' put: aCreditCardExpirationDate.
	fieldsDict at: 'cco' put: aCreditCardOwner.
	
	"self halt."
	
	resp := WebClient htmlSubmit: (self url, '/checkOutCart') fields: fieldsDict.
	
	resp isSuccess
		ifTrue: [ |decodedResult|
			decodedResult := WebUtils jsonDecode: ((resp content) readStream).
			^decodedResult]
		ifFalse: [^self error: resp content].
	
	
	! !

!LibrosRestInterface methodsFor: 'requests' stamp: 'G.L.S 7/8/2021 15:36:47'!
sendCreateCartRequestFor: aUsername withPassword: aPassword

	| fieldsDict resp |
	fieldsDict := Dictionary new.
	fieldsDict at: 'clientId' put: aUsername.
	fieldsDict at: 'password' put: aPassword.
	
	resp := WebClient htmlSubmit: (self url, '/createCart') fields: fieldsDict.
	
	resp isSuccess
		ifTrue: [ |decodedResult|
			decodedResult := WebUtils jsonDecode: ((resp content) readStream).
			^(decodedResult copyFrom: 3 to: decodedResult size) asNumber.]
		ifFalse: [^self error: resp content].
	
	! !

!LibrosRestInterface methodsFor: 'requests' stamp: 'G.L.S 7/7/2021 20:16:02'!
sendGetCatalog

	| fieldsDict resp |
	fieldsDict := Dictionary new.
	
	resp := WebClient htmlSubmit: (self url, '/getCatalog') fields: fieldsDict.
	
	resp isSuccess
		ifTrue: [^WebUtils jsonDecode: ((resp content) readStream)]
		ifFalse: [^self error: resp content].
	
	! !

!LibrosRestInterface methodsFor: 'requests' stamp: 'G.L.S 7/7/2021 17:32:26'!
sendListCartFor: aCartId

	| fieldsDict resp |
	fieldsDict := Dictionary new.
	fieldsDict at: 'cartId' put: aCartId.
	
	resp := WebClient htmlSubmit: (self url, '/listCart') fields: fieldsDict.
	
	resp isSuccess
		ifTrue: [^WebUtils jsonDecode: ((resp content) readStream)]
		ifFalse: [^self error: resp content].
	
	! !

!LibrosRestInterface methodsFor: 'requests' stamp: 'G.L.S 7/7/2021 21:05:37'!
sendListPurchasesRequestFor: aUsername withPassword: aPassword

	| fieldsDict resp |
	fieldsDict := Dictionary new.
	fieldsDict at: 'clientId' put: aUsername.
	fieldsDict at: 'password' put: aPassword.
	
	resp := WebClient htmlSubmit: (self url, '/listPurchases') fields: fieldsDict.
	
	resp isSuccess
		ifTrue: [^WebUtils jsonDecode: ((resp content) readStream)]
		ifFalse: [^self error: resp content].
	
	! !

!LibrosRestInterface methodsFor: 'requests' stamp: 'G.L.S 7/7/2021 18:00:00'!
sendRemoveFromCartRequestWithCart: aCartId bookISBN: aISBN amount: anAmount
	
	| fieldsDict resp |
	fieldsDict := Dictionary new.
	fieldsDict at: 'cartId' put: aCartId.
	fieldsDict at: 'bookIsbn' put: aISBN.
	fieldsDict at: 'bookQuantity' put: anAmount.
	
	resp := WebClient htmlSubmit: (self url, '/removeFromCart') fields: fieldsDict.
	
	resp isSuccess ifFalse: [^self error: resp content].
	! !


!classDefinition: #LibrosServer category: 'Ejercicio-Libros'!
Object subclass: #LibrosServer
	instanceVariableNames: 'mockInterface port webServer storeOF'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!LibrosServer methodsFor: 'service startup' stamp: 'G.L.S 6/28/2021 21:04:23'!
startAddToCartService.

	self addInterfaceService: '/addToCart' withAction: [
		:request | 
		|cartId bookIsbn bookQuantity result| 
			cartId := (request fields at:'cartId') asNumber.
			bookIsbn := (request fields at:'bookIsbn').
			bookQuantity := (request fields at:'bookQuantity') asNumber.
			
			mockInterface add: bookQuantity ofItem: bookIsbn toCart: cartId.
			
        			result := WebUtils jsonEncode: ('0|', 'OK').
    			request send200Response: result.
		].! !

!LibrosServer methodsFor: 'service startup' stamp: 'G.L.S 7/8/2021 00:16:34'!
startCheckOutCartService

	self addInterfaceService: '/checkOutCart' withAction: [
		:request | 
		|cartId ccn cced cco resultString result checkoutResume |
			
			cartId := (request fields at:'cartId') asNumber.
			ccn := (request fields at:'ccn').
			cced := self processExpirationDateFrom: (request fields at:'cced').
			cco := (request fields at:'cco'). 
			
			checkoutResume := mockInterface checkOutCart: cartId  
							withCreditCard: ccn
							withExpirationDate: cced 
							withOwner: cco.
			
			resultString := '0|', ((checkoutResume at: 'id') asString), '|'.
			
			checkoutResume keysDo:[ :key |
				(key = 'total' or: [key = 'id']) ifFalse: [resultString := resultString, key, '|', (checkoutResume at: key) asString, '|'].
				].
			
			resultString := resultString, 'total|', (checkoutResume at: 'total') asString, '|'.
			
        			result := WebUtils jsonEncode: (resultString).
    			request send200Response: result.
		].
! !

!LibrosServer methodsFor: 'service startup' stamp: 'G.L.S 6/28/2021 21:01:24'!
startCreateCartService.

	self addInterfaceService: '/createCart' withAction: [ 
		:request |
		|clientId password cartId result| 
			clientId := (request fields at:'clientId').
      			password := (request fields at:'password').
			cartId := mockInterface createCartForUser: clientId password: password.
			
        			result := WebUtils jsonEncode: ('0|', cartId asString).
    			request send200Response: result.
		].! !

!LibrosServer methodsFor: 'service startup' stamp: 'G.L.S 7/7/2021 20:15:15'!
startGetCatalogService

	self addInterfaceService: '/getCatalog' withAction: [
		:request | 
		|catalog result|
		
			catalog := mockInterface getCatalog.
			
        			result := WebUtils jsonEncode: (catalog).
    			request send200Response: result.
		].! !

!LibrosServer methodsFor: 'service startup' stamp: 'G.L.S 6/28/2021 21:01:30'!
startListCartService

	self addInterfaceService: '/listCart' withAction: [
		:request | 
		|cartId cartList resultString result|
			
			cartId := (request fields at:'cartId') asNumber.
			cartList := mockInterface listCart: cartId.
			
			resultString := '0|'.
			
			cartList do: [ :cartItem |
					resultString := resultString, cartItem first asString, '|'.
					resultString := resultString, cartItem second asString, '|'.
				].
			
        			result := WebUtils jsonEncode: (resultString).
    			request send200Response: result.
		].! !

!LibrosServer methodsFor: 'service startup' stamp: 'G.L.S 7/7/2021 23:07:35'!
startListPurchasesService
	
	self addInterfaceService: '/listPurchases' withAction: [
		:request | 
		|clientId password list resultString result | 
			
			clientId := (request fields at:'clientId').
      			password := (request fields at:'password').
			
			list := mockInterface listPurchasesForUser: clientId withPassword: password.
			
			resultString := '0|'.
			
			list keysDo:[ :key |
				(key = 'totalBooks') ifFalse: [resultString := resultString, key, '|', (list at: key) asString, '|'].
				].
			
			resultString := resultString, 'totalBooks|', (list at: 'totalBooks') asString, '|'.
			
        			result := WebUtils jsonEncode: (resultString).
    			request send200Response: result.
		]
	! !

!LibrosServer methodsFor: 'service startup' stamp: 'G.L.S 7/7/2021 18:16:00'!
startRemoveFromCartService

	self addInterfaceService: '/removeFromCart' withAction: [
		:request | 
		|cartId bookIsbn bookQuantity result| 
			cartId := (request fields at:'cartId') asNumber.
			bookIsbn := (request fields at:'bookIsbn').
			bookQuantity := (request fields at:'bookQuantity') asNumber.
			
			mockInterface remove: bookQuantity ofItem: bookIsbn fromCart: cartId.
			
        			result := WebUtils jsonEncode: ('0|', 'OK').
    			request send200Response: result.
		].! !


!LibrosServer methodsFor: 'private' stamp: 'G.L.S 7/8/2021 15:36:31'!
addInterfaceService: aServiceName withAction: anActionBlock

	webServer addService: aServiceName action: [ 
		:request |
		[anActionBlock value: request]
		on: Error
		do:[ :anError |
			request send400Response: '1|#', anError messageText, '#'].
		].! !

!LibrosServer methodsFor: 'private' stamp: 'G.L.S 7/3/2021 18:19:32'!
port

	^port ifNil: [port:=8080].! !

!LibrosServer methodsFor: 'private' stamp: 'G.L.S 6/29/2021 18:56:18'!
processExpirationDateFrom: aString
	
	| expMonth expYear tempString |
	
	tempString := ''.
			
	aString do:[ :char |
			char = $/ 
			ifTrue:[		expYear := tempString asNumber.
					tempString := ''.]
			ifFalse:[tempString := tempString, char asString]
		].
			
			expMonth := tempString asNumber.
			
	^FixedGregorianDate fromDate: (Date year: expYear month: expMonth day: 1).
! !


!LibrosServer methodsFor: 'initialization' stamp: 'G.L.S 7/7/2021 20:15:29'!
initializeWith: aPortNumber
	
	storeOF := StoreObjectFactory new.
	
	mockInterface := storeOF createDefaultMockInterface.
	
	port := aPortNumber.
	
	webServer := WebServer new listenOn: port.
	
	self startCreateCartService.
	self startAddToCartService.
	self startRemoveFromCartService.
	self startGetCatalogService.
	self startListCartService.
	self startCheckOutCartService.
	self startListPurchasesService.! !


!LibrosServer methodsFor: 'destruction' stamp: 'G.L.S 6/28/2021 19:24:44'!
destroy
	
	webServer ifNotNil:[webServer destroy].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LibrosServer class' category: 'Ejercicio-Libros'!
LibrosServer class
	instanceVariableNames: ''!

!LibrosServer class methodsFor: 'instance creation' stamp: 'G.L.S 6/27/2021 20:47:31'!
listeningOn: aPortNumber

	^self new initializeWith: aPortNumber.! !


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


!MockMerchantProcesor methodsFor: 'operations' stamp: 'G.L.S 6/21/2021 19:35:03'!
can: aCreditCard spend: aTotal
	
	| storedCard |
	
	registeredCards keysDo: [
		:storedCreditCard |
		storedCreditCard = aCreditCard ifTrue: [storedCard := storedCreditCard].
		].
	
	^ (registeredCards at:storedCard) >= aTotal.! !

!MockMerchantProcesor methodsFor: 'operations' stamp: 'G.L.S 6/21/2021 18:47:23'!
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


!classDefinition: #MockRestInterface category: 'Ejercicio-Libros'!
Object subclass: #MockRestInterface
	instanceVariableNames: 'datosUsuarios catalog carts lastId userPurchases timer cartTimers salesBook merchantProcesor transactionId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!MockRestInterface methodsFor: 'checkout' stamp: 'G.L.S 7/8/2021 00:09:25'!
checkOutCart: aCartId withCreditCard: aCreditCardNumber withExpirationDate: aDate withOwner: anOwner
	
	| cartToCheckout creditCard cashier cartUser checkoutResume |
	
	cartToCheckout := self cartForId: aCartId.
	cartUser := self userOfCart: aCartId.
	creditCard := CreditCard forOwner: anOwner withNumber: aCreditCardNumber withExpirationDate: aDate.
	
	cashier := Cashier withCatalog: catalog.
	
	self assertCartTimerDidNotExpireFor: aCartId.
	
	cashier checkout: cartToCheckout 
		withCreditCard: creditCard 
		onDate: FixedGregorianDate today
		registerOn: salesBook
		forMerchantProcessor: merchantProcesor.
	
	transactionId := transactionId + 1.
	
	checkoutResume := Dictionary new.
	checkoutResume add: 'id' -> transactionId.
	checkoutResume add: 'total' -> cartToCheckout totalItemPrice.
	
	self addCartItemsFrom: aCartId to: checkoutResume.
	
	self updatePurchasesFor: cartUser withCart: aCartId withTotal: cartToCheckout totalItemPrice.
	self deleteCart: aCartId.
	
	^checkoutResume.
! !


!MockRestInterface methodsFor: 'private' stamp: 'G.L.S 7/8/2021 00:11:35'!
addCartItemsFrom: aCartId to: checkoutResume.

	(self listCart: aCartId) do:[
		:aBookAmountTuple |
		checkoutResume add: (aBookAmountTuple first) -> aBookAmountTuple second.
		].
	
! !

!MockRestInterface methodsFor: 'private' stamp: 'G.L.S 6/20/2021 19:50:53'!
assertCartExists: aCartID. 

	(carts includesKey: aCartID) ifFalse: [self error: self class errorCartIdDoesNotExist.].! !

!MockRestInterface methodsFor: 'private' stamp: 'G.L.S 6/28/2021 17:57:56'!
assertCartTimerDidNotExpireFor: aCartID

	| cartTimer |
	
	cartTimer := cartTimers at: aCartID.
	
	(timer isDifferenceWith: cartTimer biggerThan: 30) ifTrue: [self error: self class errorCartExpired].
! !

!MockRestInterface methodsFor: 'private' stamp: 'G.L.S 6/21/2021 15:55:13'!
assertUser: aUser existsWithPassword: aPassword.

	((datosUsuarios includesKey: aUser) and: [(datosUsuarios at:aUser) = aPassword]) ifFalse: [self error: self class errorWrongUserCredentials].! !

!MockRestInterface methodsFor: 'private' stamp: 'G.L.S 6/22/2021 17:31:45'!
cartForId: aCartId
	
	self assertCartExists: aCartId.
	^(carts at: aCartId) first.
! !

!MockRestInterface methodsFor: 'private' stamp: 'G.L.S 6/29/2021 19:53:11'!
deleteCart: aCartId
	
	carts removeKey: aCartId.
	cartTimers removeKey: aCartId.! !

!MockRestInterface methodsFor: 'private' stamp: 'G.L.S 6/21/2021 15:42:58'!
listCartItemsFor: aCartItemList
	^aCartItemList.
	! !

!MockRestInterface methodsFor: 'private' stamp: 'G.L.S 6/28/2021 16:35:29'!
updateCartTimerFor: aCartID

	cartTimers at: aCartID put: timer now.
	! !

!MockRestInterface methodsFor: 'private' stamp: 'G.L.S 6/22/2021 18:19:07'!
updatePurchasesFor: aUser withCart: aCartId withTotal: aTotal .
	
	(self listCart: aCartId) do: [
		:aBookAmountTuple |
		(userPurchases at: aUser) at: aBookAmountTuple first 
			ifPresent:[:cant | (userPurchases at: aUser) at: aBookAmountTuple first put: cant + aBookAmountTuple second] 
			ifAbsent:[(userPurchases at: aUser) at: aBookAmountTuple first put: aBookAmountTuple second].
		(userPurchases at:aUser) at: 'totalBooks' put: ((userPurchases at:aUser) at: 'totalBooks') + aTotal.
		].
! !

!MockRestInterface methodsFor: 'private' stamp: 'G.L.S 6/22/2021 17:31:39'!
userOfCart: aCartId

	self assertCartExists: aCartId.
	^(carts at: aCartId) second.
! !


!MockRestInterface methodsFor: 'initialization' stamp: 'G.L.S 6/28/2021 21:37:57'!
initializeFor: aUserDataDictionary withCatalog: aCatalog withTimer: aTimer withSalesBook: aSalesBook withMerchantProcesor: aMerchantProcesor

	datosUsuarios := aUserDataDictionary.
	catalog := aCatalog.
	carts := Dictionary new.
	cartTimers := Dictionary new.
	lastId := 0.
	transactionId := 0.
	
	timer := aTimer.
	salesBook  := aSalesBook.
	merchantProcesor := aMerchantProcesor.
	
	userPurchases := Dictionary new.
	
	datosUsuarios keysDo: [
			:aUserId | 
			userPurchases add: aUserId -> Dictionary new.
			(userPurchases at: aUserId) add: 'totalBooks' -> 0.
		].
	! !


!MockRestInterface methodsFor: 'operations' stamp: 'G.L.S 6/22/2021 18:14:16'!
add: anAmount ofItem: anItemID toCart: aCartID 
	
	| cart |
	
	cart := self cartForId: aCartID.
	
	self assertCartTimerDidNotExpireFor: aCartID.
	
	cart add: anItemID amount: anAmount.
	
	self updateCartTimerFor: aCartID.
	! !

!MockRestInterface methodsFor: 'operations' stamp: 'G.L.S 6/28/2021 16:44:11'!
createCartForUser: aUser password: aPassword 
	
	| newId |
	self assertUser: aUser existsWithPassword: aPassword.
	
	newId := lastId + 1.
	carts add: newId -> OrderedCollection new.
	cartTimers add: newId -> timer now.
	
	(carts at: newId) add: (Cart createNewWithCatalog: catalog).
	(carts at: newId) add: aUser.
	
	lastId := newId.
	
	^newId.! !

!MockRestInterface methodsFor: 'operations' stamp: 'G.L.S 7/7/2021 20:05:02'!
getCatalog
	
	^catalog.! !

!MockRestInterface methodsFor: 'operations' stamp: 'G.L.S 6/28/2021 19:49:23'!
listCart: aCartId 
	
	| cartItemList cart |
	
	"self halt."
	
	cart := self cartForId: aCartId.
	
	self assertCartTimerDidNotExpireFor: aCartId.
	
	cartItemList := cart itemListFor: self.
	
	self updateCartTimerFor: aCartId.
	
	^cartItemList.! !

!MockRestInterface methodsFor: 'operations' stamp: 'G.L.S 6/21/2021 17:33:33'!
listPurchasesForUser: aUser withPassword: aPassword 
	
	self assertUser: aUser existsWithPassword: aPassword.
	
	^userPurchases at: aUser.! !

!MockRestInterface methodsFor: 'operations' stamp: 'G.L.S 7/7/2021 18:15:30'!
remove: anAmount ofItem: anItemID fromCart: aCartID 
	
	| cart |
	
	cart := self cartForId: aCartID.
	
	self assertCartTimerDidNotExpireFor: aCartID.
	
	cart remove: anItemID amount: anAmount.
	
	self updateCartTimerFor: aCartID.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MockRestInterface class' category: 'Ejercicio-Libros'!
MockRestInterface class
	instanceVariableNames: ''!

!MockRestInterface class methodsFor: 'error handling' stamp: 'G.L.S 6/28/2021 21:21:36'!
createFor: aUserDataDictionary withCatalog: aCatalog withTimer: aTimer withSalesBook: aSalesBook withMerchantProcesor: aMerchantProcesor

	^self new initializeFor: aUserDataDictionary withCatalog: aCatalog withTimer: aTimer withSalesBook: aSalesBook withMerchantProcesor: aMerchantProcesor.! !

!MockRestInterface class methodsFor: 'error handling' stamp: 'G.L.S 6/22/2021 18:07:18'!
errorCartExpired
	^ 'Error - El carrito utilizado expiró'.! !

!MockRestInterface class methodsFor: 'error handling' stamp: 'G.L.S 6/20/2021 18:01:47'!
errorCartIdDoesNotExist
	^'Error - No existe un carrito con esa ID'.! !

!MockRestInterface class methodsFor: 'error handling' stamp: 'G.L.S 6/17/2021 21:24:23'!
errorWrongUserCredentials
	^'Error - Las credenciales del usuario no son correctas'.! !


!classDefinition: #MockTimer category: 'Ejercicio-Libros'!
Object subclass: #MockTimer
	instanceVariableNames: 'currentTime manualyPased'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!MockTimer methodsFor: 'initialization' stamp: 'G.L.S 6/28/2021 17:59:17'!
initialize

	self initialize: DateAndTime now.! !

!MockTimer methodsFor: 'initialization' stamp: 'G.L.S 6/28/2021 17:59:27'!
initialize: aTime

	currentTime := aTime.
	manualyPased  := false.! !


!MockTimer methodsFor: 'operation' stamp: 'G.L.S 6/28/2021 18:00:43'!
isDifferenceWith: aTimer biggerThan: anAmountOfTime
	|actualTimer|
	actualTimer  := manualyPased ifTrue: [currentTime] ifFalse: [self now].
	^((actualTimer - aTimer) minutes abs > anAmountOfTime).
	
	! !

!MockTimer methodsFor: 'operation' stamp: 'G.L.S 6/28/2021 17:55:42'!
now
	currentTime := DateAndTime now.
	^currentTime.! !

!MockTimer methodsFor: 'operation' stamp: 'G.L.S 6/28/2021 19:04:32'!
passTime: anAmontOfTime

	self now.
	currentTime := currentTime + anAmontOfTime minutes.
	manualyPased := true.! !


!classDefinition: #StoreObjectFactory category: 'Ejercicio-Libros'!
Object subclass: #StoreObjectFactory
	instanceVariableNames: 'smalltalk80 designPatterns objectThinking donQuixote workingCreditCard'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Libros'!

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 7/7/2021 16:02:26'!
createDefaultCatalog

	| catalog |
	
	catalog := Dictionary new.
	"catalog add: smalltalk80 -> 10.
	catalog add: designPatterns -> 100.
	catalog add: objectThinking -> 50."
	
	catalog add: smalltalk80 -> Dictionary new.
	(catalog at: smalltalk80) at: 'nombre' put: 'SMALLTALK-80'.
	(catalog at: smalltalk80) at: 'precio' put: 10.
	
	catalog add: designPatterns -> Dictionary new.
	(catalog at: designPatterns) at: 'nombre' put: 'The Design Patterns Smalltalk Companion'.
	(catalog at: designPatterns) at: 'precio' put: 100.
	
	catalog add: objectThinking -> Dictionary new.
	(catalog at: objectThinking) at: 'nombre' put: 'Object Thinking'.
	(catalog at: objectThinking) at: 'precio' put: 50.
	
	^catalog! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 7/7/2021 22:55:16'!
createDefaultCreditCardExpirationDate

	| monthNumber yearNumber |
	monthNumber := FixedGregorianDate tomorrow month number.
	
	monthNumber := (monthNumber < 10) ifTrue:['0', monthNumber asString] ifFalse:[monthNumber asString].
	
	yearNumber := FixedGregorianDate tomorrow year next number asString.
	
	^ yearNumber,'/', monthNumber.! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 7/7/2021 18:50:07'!
createDefaultCreditCardNumber

	^'0000000000000000'! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 7/7/2021 18:49:52'!
createDefaultCreditCardOwner
	
	^'Marco'.! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/28/2021 21:32:32'!
createDefaultMerchantProcesor

	| merchantProcessor |
	
	merchantProcessor := MockMerchantProcesor new.
	merchantProcessor registerCard: workingCreditCard withBalance: 1000.
	
	^merchantProcessor.! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/28/2021 21:22:41'!
createDefaultMockInterface

	| mockInterface |
	
	mockInterface := MockRestInterface createFor: self createDefaultUserData 
					withCatalog: self createDefaultCatalog 
					withTimer: self createDefaultMockTimer
					withSalesBook: self createDefaultSalesBook 
					withMerchantProcesor: self createDefaultMerchantProcesor.
	
	^mockInterface! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/28/2021 16:15:41'!
createDefaultMockTimer

	^MockTimer new.! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/28/2021 15:58:19'!
createDefaultSalesBook

	^ OrderedCollection new.! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/28/2021 16:16:05'!
createDefaultTimer

	self shouldBeImplemented.! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 7/8/2021 15:56:50'!
createDefaultUserData
	
	| userData |
	
	userData := Dictionary new.
	userData add: 'pepe' -> '5678'.
	userData add: 'ramon' -> '1234'.
	
	^ userData.! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/28/2021 16:03:05'!
createEmptyCatalog

	^Dictionary new.! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/28/2021 21:22:04'!
createMerchantProcesor

	^MockMerchantProcesor new.! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 7/7/2021 16:03:44'!
createSingleItemCatalog

	| catalog |
	
	catalog := Dictionary new.
	"catalog add: donQuixote -> 50."
	
	catalog add: donQuixote -> Dictionary new.
	(catalog at: donQuixote) at: 'nombre' put: 'Don Quixote (Don Quijote de la Mancha)'.
	(catalog at: donQuixote) at: 'precio' put: 50.
	
	^catalog! !

!StoreObjectFactory methodsFor: 'as yet unclassified' stamp: 'G.L.S 6/28/2021 21:32:27'!
initialize

	smalltalk80 := '9780201113723'.
	designPatterns := '9780201184624'.
	objectThinking := '9780735619654'.
	donQuixote := '9781400132171'.
	
	workingCreditCard := CreditCard forOwner: 'Marco' withNumber: '0000000000000000' withExpirationDate: FixedGregorianDate tomorrow.! !
