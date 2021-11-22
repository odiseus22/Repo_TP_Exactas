!classDefinition: #NumeroTest category: 'Numero-Exercise'!
TestCase subclass: #NumeroTest
	instanceVariableNames: 'zero one two four oneFifth oneHalf five twoFifth twoTwentyfifth fiveHalfs three eight negativeOne negativeTwo'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:11'!
test01isCeroReturnsTrueWhenAskToZero

	self assert: zero isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:12'!
test02isCeroReturnsFalseWhenAskToOthersButZero

	self deny: one isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:13'!
test03isOneReturnsTrueWhenAskToOne

	self assert: one isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:13'!
test04isOneReturnsFalseWhenAskToOtherThanOne

	self deny: zero isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:14'!
test05EnteroAddsWithEnteroCorrectly

	self assert: one + one equals: two! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:18'!
test06EnteroMultipliesWithEnteroCorrectly

	self assert: two * two equals: four! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:20'!
test07EnteroDividesEnteroCorrectly

	self assert: two / two equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:38'!
test08FraccionAddsWithFraccionCorrectly
"
    La suma de fracciones es:
	 
	a/b + c/d = (a.d + c.b) / (b.d)
	 
	SI ESTAN PENSANDO EN LA REDUCCION DE FRACCIONES NO SE PREOCUPEN!!
	TODAVIA NO SE ESTA TESTEANDO ESE CASO
"
	| sevenTenths |

	sevenTenths := (Entero with: 7) / (Entero with: 10).

	self assert: oneFifth + oneHalf equals: sevenTenths! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:52'!
test09FraccionMultipliesWithFraccionCorrectly
"
    La multiplicacion de fracciones es:
	 
	(a/b) * (c/d) = (a.c) / (b.d)
"

	self assert: oneFifth * twoFifth equals: twoTwentyfifth! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:56'!
test10FraccionDividesFraccionCorrectly
"
    La division de fracciones es:
	 
	(a/b) / (c/d) = (a.d) / (b.c)
"

	self assert: oneHalf / oneFifth equals: fiveHalfs! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:07'!
test11EnteroAddsFraccionCorrectly
"
	Ahora empieza la diversion!!
"

	self assert: one + oneFifth equals: (Entero with: 6) / (Entero with: 5)! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:07'!
test12FraccionAddsEnteroCorrectly

	self assert: oneFifth + one equals: (Entero with: 6) / (Entero with: 5)! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:50'!
test13EnteroMultipliesFraccionCorrectly

	self assert: two * oneFifth equals: twoFifth ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:52'!
test14FraccionMultipliesEnteroCorrectly

	self assert: oneFifth * two equals: twoFifth ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:57'!
test15EnteroDividesFraccionCorrectly

	self assert: one / twoFifth equals: fiveHalfs  ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:59'!
test16FraccionDividesEnteroCorrectly

	self assert: twoFifth / five equals: twoTwentyfifth ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:38'!
test17AFraccionCanBeEqualToAnEntero

	self assert: two equals: four / two! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:39'!
test18AparentFraccionesAreEqual

	self assert: oneHalf equals: two / four! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:40'!
test19AddingFraccionesCanReturnAnEntero

	self assert: oneHalf + oneHalf equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:42'!
test20MultiplyingFraccionesCanReturnAnEntero

	self assert: (two/five) * (five/two) equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:42'!
test21DividingFraccionesCanReturnAnEntero

	self assert: oneHalf / oneHalf equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:43'!
test22DividingEnterosCanReturnAFraccion

	self assert: two / four equals: oneHalf! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:46'!
test23CanNotDivideEnteroByZero

	self 
		should: [ one / zero ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Numero canNotDivideByZeroErrorDescription ]
	! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:46'!
test24CanNotDivideFraccionByZero

	self 
		should: [ oneHalf / zero ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Numero canNotDivideByZeroErrorDescription ]
	! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:50'!
test25AFraccionCanNotBeZero

	self deny: oneHalf isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:50'!
test26AFraccionCanNotBeOne

	self deny: oneHalf isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 4/15/2021 16:45:35'!
test27EnteroSubstractsEnteroCorrectly

	self assert: four - one equals: three! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:47:41'!
test28FraccionSubstractsFraccionCorrectly
	
	self assert: twoFifth - oneFifth equals: oneFifth.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:48:00'!
test29EnteroSubstractsFraccionCorrectly

	self assert: one - oneHalf equals: oneHalf! !

!NumeroTest methodsFor: 'tests' stamp: 'HAW 9/24/2018 08:48:05'!
test30FraccionSubstractsEnteroCorrectly

	| sixFifth |
	
	sixFifth := (Entero with: 6) / (Entero with: 5).
	
	self assert: sixFifth - one equals: oneFifth! !

!NumeroTest methodsFor: 'tests' stamp: 'HAW 9/24/2018 08:48:08'!
test31SubstractingFraccionesCanReturnAnEntero

	| threeHalfs |
	
	threeHalfs := (Entero with: 3) / (Entero with: 2).
	
	self assert: threeHalfs - oneHalf equals: one.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:48:48'!
test32SubstractingSameEnterosReturnsZero

	self assert: one - one equals: zero.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:01'!
test33SubstractingSameFraccionesReturnsZero

	self assert: oneHalf - oneHalf equals: zero.! !

!NumeroTest methodsFor: 'tests' stamp: 'HAW 9/24/2018 08:48:14'!
test34SubstractingAHigherValueToANumberReturnsANegativeNumber

	| negativeThreeHalfs |
	
	negativeThreeHalfs := (Entero with: -3) / (Entero with: 2).	

	self assert: one - fiveHalfs equals: negativeThreeHalfs.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:23'!
test35FibonacciZeroIsOne

	self assert: zero fibonacci equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:32'!
test36FibonacciOneIsOne

	self assert: one fibonacci equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:39'!
test37FibonacciEnteroReturnsAddingPreviousTwoFibonacciEnteros

	self assert: four fibonacci equals: five.
	self assert: three fibonacci equals: three. 
	self assert: five fibonacci equals: four fibonacci + three fibonacci.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:47'!
test38FibonacciNotDefinedForNegativeNumbers

	self 
		should: [negativeOne fibonacci]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Entero negativeFibonacciErrorDescription ].! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:55'!
test39NegationOfEnteroIsCorrect

	self assert: two negated equals: negativeTwo.
		! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:50:03'!
test40NegationOfFraccionIsCorrect

	self assert: oneHalf negated equals: negativeOne / two.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:50:11'!
test41SignIsCorrectlyAssignedToFractionWithTwoNegatives

	self assert: oneHalf equals: (negativeOne / negativeTwo)! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:50:17'!
test42SignIsCorrectlyAssignedToFractionWithNegativeDivisor

	self assert: oneHalf negated equals: (one / negativeTwo)! !


!NumeroTest methodsFor: 'setup' stamp: 'NR 9/23/2018 23:46:28'!
setUp

	zero := Entero with: 0.
	one := Entero with: 1.
	two := Entero with: 2.
	three:= Entero with: 3.
	four := Entero with: 4.
	five := Entero with: 5.
	eight := Entero with: 8.
	negativeOne := Entero with: -1.
	negativeTwo := Entero with: -2.
	
	oneHalf := one / two.
	oneFifth := one / five.
	twoFifth := two / five.
	twoTwentyfifth := two / (Entero with: 25).
	fiveHalfs := five / two.
	! !


!classDefinition: #Numero category: 'Numero-Exercise'!
Object subclass: #Numero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:48'!
* aMultiplier

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:49'!
+ anAdder

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'NR 9/23/2018 22:21:28'!
- aSubtrahend

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:49'!
/ aDivisor

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:48'!
invalidNumberType

	self error: self class invalidNumberTypeErrorDescription! !

!Numero methodsFor: 'arithmetic operations' stamp: 'NR 9/23/2018 23:37:13'!
negated
	
	^self * (Entero with: -1)! !


!Numero methodsFor: 'testing' stamp: 'NR 9/23/2018 23:36:49'!
isNegative

	self subclassResponsibility ! !

!Numero methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:49'!
isOne

	self subclassResponsibility ! !

!Numero methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:49'!
isZero

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Numero class' category: 'Numero-Exercise'!
Numero class
	instanceVariableNames: ''!

!Numero class methodsFor: 'error descriptions' stamp: 'NR 4/15/2021 16:42:02'!
canNotDivideByZeroErrorDescription

	^'No se puede dividir por cero!!!!!!'! !

!Numero class methodsFor: 'error descriptions' stamp: 'NR 4/15/2021 16:42:09'!
invalidNumberTypeErrorDescription
	
	^ 'Tipo de número inválido!!!!!!'! !


!classDefinition: #Entero category: 'Numero-Exercise'!
Numero subclass: #Entero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Entero methodsFor: 'private' stamp: 'jul 4/19/2021 23:44:10'!
addFraction: aFraction

	^aFraction addInteger: self.! !

!Entero methodsFor: 'private' stamp: 'GS 4/22/2021 12:29:53'!
addInteger: anInteger
	
	^self class with: self integerValue + anInteger integerValue.
! !

!Entero methodsFor: 'private' stamp: 'GS 4/22/2021 15:03:31'!
canDivide! !

!Entero methodsFor: 'private' stamp: 'jul 4/19/2021 23:46:26'!
dividesFraction: aFraction

	^Fraccion with: aFraction numerator over: self * aFraction denominator.! !

!Entero methodsFor: 'private' stamp: 'jul 4/19/2021 23:39:47'!
dividesInteger: anIntegerNumerator

	^Fraccion with: anIntegerNumerator over: self! !

!Entero methodsFor: 'private' stamp: 'GS 4/22/2021 16:34:39'!
invertCollaboratorWhenNegative: aNum
	^aNum! !

!Entero methodsFor: 'private' stamp: 'jul 4/19/2021 21:05:14'!
multiplyByFraction: aFraction

	^aFraction multiplyByInteger: self

! !

!Entero methodsFor: 'private' stamp: 'GS 4/22/2021 12:30:54'!
multiplyByInteger: anInteger

	^self class with: self integerValue * anInteger integerValue

! !

!Entero methodsFor: 'private' stamp: 'GS 4/22/2021 15:13:29'!
returnWhenCero
	^[]! !

!Entero methodsFor: 'private' stamp: 'GS 4/22/2021 12:31:04'!
substracFromFraction:  anFractionMinuend


	^Fraccion with: (anFractionMinuend numerator - (self * anFractionMinuend denominator)) over:  (anFractionMinuend denominator).
	
! !

!Entero methodsFor: 'private' stamp: 'GS 4/22/2021 12:31:31'!
substracFromInteger:  anIntegerMinuend

	^ self class with: anIntegerMinuend integerValue - self integerValue.! !

!Entero methodsFor: 'private' stamp: 'GS 4/22/2021 14:41:44'!
validDenominator! !

!Entero methodsFor: 'private' stamp: 'GS 4/22/2021 14:35:14'!
validNumerator! !


!Entero methodsFor: 'arithmetic operations' stamp: 'jul 4/19/2021 21:11:00'!
* aMultiplier 
	
	^aMultiplier multiplyByInteger: self.
! !

!Entero methodsFor: 'arithmetic operations' stamp: 'jul 4/19/2021 17:04:56'!
+ anAdder 	

	^anAdder addInteger: self.! !

!Entero methodsFor: 'arithmetic operations' stamp: 'jul 4/21/2021 15:03:30'!
- aSubtrahend 

	^aSubtrahend substracFromInteger: self.	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'jul 4/19/2021 21:29:09'!
/ aDivisor 
	
	^aDivisor  dividesInteger:  self.
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'GS 4/22/2021 13:18:34'!
// aDivisor 
	
	^self class with: self integerValue // aDivisor integerValue! !

!Entero methodsFor: 'arithmetic operations' stamp: 'GS 4/22/2021 12:30:27'!
fibonacci
	^self subclassResponsibility.! !

!Entero methodsFor: 'arithmetic operations' stamp: 'GS 4/22/2021 12:32:17'!
greatestCommonDivisorWith: anEntero 
	
	^self class with: (self integerValue gcd: anEntero integerValue)! !


!Entero methodsFor: 'comparing' stamp: 'GS 4/22/2021 13:07:07'!
= anObject

	^(anObject isKindOf: self class) and: [ self integerValue = anObject integerValue ]! !

!Entero methodsFor: 'comparing' stamp: 'GS 4/22/2021 13:07:22'!
hash

	^self integerValue hash! !


!Entero methodsFor: 'initialization' stamp: 'GS 4/22/2021 13:14:34'!
initalizeWith: aValue 
	
	(aValue = 0) ifTrue:[^Cero new].
	(aValue = 1) ifTrue:[^Uno new].
	(aValue < 0) ifTrue:[^Negativo new initializeWith: aValue].
	(aValue > 1) ifTrue:[^PositivoMayorAUno new initializeWith: aValue].
	
	self error: self class errorInvalidValue.


! !


!Entero methodsFor: 'value' stamp: 'GS 4/22/2021 13:02:23'!
integerValue

	"Usamos integerValue en vez de value para que no haya problemas con el mensaje value implementado en Object - Hernan"
	
	^self subclassResponsibility ! !


!Entero methodsFor: 'printing' stamp: 'GS 4/22/2021 13:17:58'!
printOn: aStream

	aStream print: self integerValue ! !


!Entero methodsFor: 'testing' stamp: 'GS 4/22/2021 13:17:41'!
isNegative
	
	^self integerValue < 0! !

!Entero methodsFor: 'testing' stamp: 'GS 4/22/2021 12:59:04'!
isOne
	
	^self integerValue = 1! !

!Entero methodsFor: 'testing' stamp: 'GS 4/22/2021 12:59:14'!
isZero
	
	^self integerValue = 0! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Entero class' category: 'Numero-Exercise'!
Entero class
	instanceVariableNames: ''!

!Entero class methodsFor: 'instance creation' stamp: 'jul 4/21/2021 15:35:04'!
errorInvalidValue
	^ 'El parametro de inicializacion aValue no es valido'! !

!Entero class methodsFor: 'instance creation' stamp: 'NR 4/15/2021 16:42:24'!
negativeFibonacciErrorDescription
	^ ' Fibonacci no está definido aquí para Enteros Negativos!!!!!!'! !

!Entero class methodsFor: 'instance creation' stamp: 'HernanWilkinson 5/7/2016 22:53'!
with: aValue 
	
	"Esta verificacion esta puesta por si se equivocan y quieren crear un Entero pasando otra cosa que un Integer - Hernan"
	aValue isInteger ifFalse: [  self error: 'aValue debe ser anInteger' ].
	
	^self new initalizeWith: aValue! !


!classDefinition: #CasosBaseFibonacci category: 'Numero-Exercise'!
Entero subclass: #CasosBaseFibonacci
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!


!CasosBaseFibonacci methodsFor: 'arithmetic operations' stamp: 'GS 4/22/2021 14:28:06'!
fibonacci
	^Entero with: 1.! !


!classDefinition: #Cero category: 'Numero-Exercise'!
CasosBaseFibonacci subclass: #Cero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Cero methodsFor: 'value' stamp: 'GS 4/22/2021 12:57:33'!
integerValue
	^0! !


!Cero methodsFor: 'private' stamp: 'GS 4/22/2021 15:03:40'!
canDivide
	^self error: self class canNotDivideByZeroErrorDescription.! !

!Cero methodsFor: 'private' stamp: 'GS 4/22/2021 15:13:29'!
returnWhenCero
	^[self]! !

!Cero methodsFor: 'private' stamp: 'GS 4/22/2021 14:41:07'!
validNumerator
	^self error: 'una fraccion no puede ser cero'! !


!classDefinition: #Uno category: 'Numero-Exercise'!
CasosBaseFibonacci subclass: #Uno
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!


!Uno methodsFor: 'value' stamp: 'GS 4/22/2021 12:57:52'!
integerValue
	^1! !

!Uno methodsFor: 'value' stamp: 'GS 4/22/2021 15:02:47'!
validDenominator
	^self error: 'una fraccion no puede tener denominador 1 porque sino es un entero'.! !


!classDefinition: #OtrosNumeros category: 'Numero-Exercise'!
Entero subclass: #OtrosNumeros
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!OtrosNumeros methodsFor: 'value' stamp: 'GS 4/22/2021 13:02:43'!
integerValue
	^value! !


!OtrosNumeros methodsFor: 'initialization' stamp: 'GS 4/21/2021 16:31:28'!
initializeWith: aValue
	value := aValue! !


!classDefinition: #Negativo category: 'Numero-Exercise'!
OtrosNumeros subclass: #Negativo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Negativo methodsFor: 'private' stamp: 'GS 4/22/2021 16:34:39'!
invertCollaboratorWhenNegative: aNum
	^aNum negated! !


!Negativo methodsFor: 'arithmetic operations' stamp: 'jul 4/21/2021 15:43:37'!
fibonacci
	^self error: Entero negativeFibonacciErrorDescription.	
	! !


!classDefinition: #PositivoMayorAUno category: 'Numero-Exercise'!
OtrosNumeros subclass: #PositivoMayorAUno
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!PositivoMayorAUno methodsFor: 'arithmetic operations' stamp: 'jul 4/21/2021 15:43:59'!
fibonacci

	| one two |
	
	one := Entero with: 1.
	two := Entero with: 2.
	
	^ (self - one) fibonacci + (self - two) fibonacci! !


!classDefinition: #Fraccion category: 'Numero-Exercise'!
Numero subclass: #Fraccion
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Fraccion methodsFor: 'arithmetic operations' stamp: 'jul 4/19/2021 21:11:19'!
* aMultiplier 
	
	^aMultiplier multiplyByFraction:  self.
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'jul 4/19/2021 20:50:12'!
+ anAdder 
	
	"| newNumerator newDenominator |
	
	newNumerator := (numerator * anAdder denominator) + (denominator * anAdder numerator).
	newDenominator := denominator * anAdder denominator.
	
	^newNumerator / newDenominator "
	
	^anAdder addFraction: self! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'jul 4/21/2021 15:10:45'!
- aSubtrahend 
	
	
	^aSubtrahend substracFromFraction: self.
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'jul 4/19/2021 21:39:35'!
/ aDivisor 
	
	^aDivisor dividesFraction:  self
	! !


!Fraccion methodsFor: 'comparing' stamp: 'HernanWilkinson 5/7/2016 20:42'!
= anObject

	^(anObject isKindOf: self class) and: [ (numerator * anObject denominator) = (denominator * anObject numerator) ]! !

!Fraccion methodsFor: 'comparing' stamp: 'HernanWilkinson 5/7/2016 20:50'!
hash

	^(numerator hash / denominator hash) hash! !


!Fraccion methodsFor: 'accessing' stamp: 'HernanWilkinson 5/7/2016 21:56'!
denominator

	^ denominator! !

!Fraccion methodsFor: 'accessing' stamp: 'HernanWilkinson 5/7/2016 21:56'!
numerator

	^ numerator! !


!Fraccion methodsFor: 'private' stamp: 'jul 4/19/2021 20:52:12'!
addFraction: aFraction

	| newNumerator newDenominator |
	
	newNumerator := (numerator * aFraction denominator) + (denominator * aFraction numerator).
	newDenominator := denominator * aFraction denominator.
	
	^newNumerator / newDenominator ! !

!Fraccion methodsFor: 'private' stamp: 'jul 4/19/2021 17:03:25'!
addInteger: anInteger

	^(self numerator + (anInteger * self denominator))/self denominator! !

!Fraccion methodsFor: 'private' stamp: 'jul 4/19/2021 21:37:25'!
dividesFraction: aFraction 

^aFraction * (self denominator / self numerator).
! !

!Fraccion methodsFor: 'private' stamp: 'jul 4/19/2021 21:28:50'!
dividesInteger: anIntegerNumerator
 	^anIntegerNumerator * (self denominator / self numerator ).! !

!Fraccion methodsFor: 'private' stamp: 'jul 4/19/2021 21:06:25'!
multiplyByFraction: aFraction

	^(numerator * aFraction numerator) / (denominator * aFraction denominator)
! !

!Fraccion methodsFor: 'private' stamp: 'jul 4/19/2021 21:08:47'!
multiplyByInteger: anInteger

	^ (self numerator*anInteger) /(self denominator).


! !

!Fraccion methodsFor: 'private' stamp: 'jul 4/21/2021 15:08:46'!
substracFromFraction:  anFractionMinuend

	| newNumerator newDenominator |

	newNumerator := (anFractionMinuend numerator * self denominator) - (self numerator * anFractionMinuend denominator).

	newDenominator :=   anFractionMinuend denominator * self denominator.

	^newNumerator / newDenominator.! !

!Fraccion methodsFor: 'private' stamp: 'jul 4/21/2021 15:14:46'!
substracFromInteger:  anIntegerMinuend

	| newNumerator newDenominator |

	newNumerator := (anIntegerMinuend * self denominator) - (self numerator).

	newDenominator := self denominator.

	^newNumerator / newDenominator.! !


!Fraccion methodsFor: 'initialization' stamp: 'GS 4/22/2021 14:47:25'!
initializeWith: aNumerator over: aDenominator

	"Estas precondiciones estan por si se comenten errores en la implementacion - Hernan"
	
	(numerator := aNumerator) validNumerator .
	(denominator := aDenominator) validDenominator .! !


!Fraccion methodsFor: 'testing' stamp: 'NR 9/23/2018 23:41:38'!
isNegative
	
	^numerator < 0! !

!Fraccion methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:51'!
isOne
	
	^false! !

!Fraccion methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:51'!
isZero
	
	^false! !


!Fraccion methodsFor: 'printing' stamp: 'HAW 9/24/2018 08:54:46'!
printOn: aStream

	aStream 
		print: numerator;
		nextPut: $/;
		print: denominator ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Fraccion class' category: 'Numero-Exercise'!
Fraccion class
	instanceVariableNames: ''!

!Fraccion class methodsFor: 'intance creation' stamp: 'GS 4/22/2021 16:34:39'!
with: aDividend over: aDivisor

	| greatestCommonDivisor numerator denominator invertedDividend invertedDivisor|
	
	aDivisor canDivide.
	
	invertedDividend  := aDivisor invertCollaboratorWhenNegative: aDividend. "isNegative ifTrue:[ ^aDividend negated / aDivisor negated]."
	invertedDivisor := aDivisor invertCollaboratorWhenNegative: aDivisor. 
	
	greatestCommonDivisor := invertedDividend greatestCommonDivisorWith: invertedDivisor. "aDividend greatestCommonDivisorWith: aDivisor. "
	numerator := invertedDividend // greatestCommonDivisor. "aDividend // greatestCommonDivisor."
	denominator := invertedDivisor // greatestCommonDivisor. "aDivisor // greatestCommonDivisor."
	
	denominator isOne ifTrue: [ ^numerator ].

	^self new initializeWith: numerator over: denominator
	! !
