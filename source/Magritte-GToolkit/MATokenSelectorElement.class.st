Class {
	#name : #MATokenSelectorElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'object',
		'relationDescription',
		'tokenContainer'
	],
	#category : #'Magritte-GToolkit-Widgets'
}

{ #category : #'visiting-description' }
MATokenSelectorElement class >> forObject: anObject withRelationDescription: aDescription [
	^ self basicNew
		object: anObject;
		relationDescription: aDescription;
		initialize;
		yourself.
]

{ #category : #initialization }
MATokenSelectorElement >> addTokenFor: anObject [
	
	| token |
	token := MATokenElement new
		label: (self relationDescription reference toString: anObject);
		object: anObject;
		removeAction: [ :obj | self onTokenRemovedFor: obj ];
		yourself.
	self tokenContainer addChild: token
]

{ #category : #initialization }
MATokenSelectorElement >> initialize [

	| searchButton |
	super initialize.
	
	self
		hMatchParent;
		padding: (BlInsets top: 4 bottom: 4);
		alignCenterLeft;
		cellSpacing: 5;
		vFitContent.
		
	searchButton := GtSpotterDropdownButtonStencil new
		valuable: [ self relationDescription gtSearchSource value ];
		icon: BrGlamorousVectorIcons search;
		spotterModelDo: [ :sm |
			sm announcer
				when: GtSpotterActOn
				do: [ :evt | 
					self onTokenRequestFor: evt element.
					evt actedUpon: true ] ];
		create.
		
	self refreshTokens.
	
	self
		addChild: searchButton;
		addChild: self tokenContainer.
]

{ #category : #accessing }
MATokenSelectorElement >> object [

	^ object
]

{ #category : #accessing }
MATokenSelectorElement >> object: anObject [

	object := anObject
]

{ #category : #initialization }
MATokenSelectorElement >> onTokenRemovedFor: anObject [
	self relationDescription write: nil to: self object
]

{ #category : #initialization }
MATokenSelectorElement >> onTokenRequestFor: anObject [
	self relationDescription write: anObject to: self object.
	self refreshTokens
]

{ #category : #initialization }
MATokenSelectorElement >> refreshTokens [

	| currentValue |
	self tokenContainer removeChildren.
	currentValue := self object readUsing: self relationDescription.
	currentValue ifNotNil: [ self addTokenFor: currentValue ].
]

{ #category : #accessing }
MATokenSelectorElement >> relationDescription [

	^ relationDescription
]

{ #category : #accessing }
MATokenSelectorElement >> relationDescription: anObject [

	relationDescription := anObject
]

{ #category : #initialization }
MATokenSelectorElement >> tokenContainer [
	tokenContainer ifNotNil: [ ^ tokenContainer ].
	
	^ tokenContainer := BrHorizontalPane new
		vFitContent;
		hFitContent;
		yourself
]
