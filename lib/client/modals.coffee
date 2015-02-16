# Template.CollectionModalButton.events
# 	'click .collection-modals': (e,t) ->
# 		$('#collection-modal').modal('show')
# 		collection = $(e.currentTarget).attr('collection')
# 		operation = $(e.currentTarget).attr('operation')
# 		_id = $(e.currentTarget).attr('doc')
# 		omitFields = $(e.currentTarget).attr('omitFields')
# 		doc = window[collection].findOne _id:_id
# 		html = $(e.currentTarget).html()

# 		Session.set('cmCollection',collection)
# 		Session.set('cmOperation',operation)
# 		Session.set('cmDoc',doc)
# 		Session.set('cmButtonHtml',html)
# 		Session.set('cmOmitFields',omitFields)

collectionObj = (name) ->
	name.split('.').reduce (o, x) ->
		o[x]
	, window

cleanSession = () ->
	sessionKeys = [
		'cmCollection',
		'cmOperation',
		'cmDoc',
		'cmButtonHtml',
		'cmFields',
		'cmOmitFields',
		'cmButtonContent',
		'cmTitle',
		'cmButtonClasses',
		'cmPrompt'
	]
	delete Session.keys[key] for key in sessionKeys
	AutoForm.invalidateFormContext 'cmForm'
	AutoForm.resetForm 'cmForm'
	return

helpers =
	cmCollection: () ->
		Session.get 'cmCollection'
	cmOperation: () ->
		Session.get 'cmOperation'
	cmDoc: () ->
		Session.get 'cmDoc'
	cmButtonHtml: () ->
		Session.get 'cmButtonHtml'
	cmFields: () ->
		Session.get 'cmFields'
	cmOmitFields: () ->
		Session.get 'cmOmitFields'
	cmButtonContent: () ->
		Session.get 'cmButtonContent'
	cmTitle: () ->
		Session.get 'cmTitle'
	cmButtonClasses: () ->
		Session.get 'cmButtonClasses'
	cmPrompt: () ->
		Session.get 'cmPrompt'
	title: () ->
		StringTemplate.compile '{{{cmTitle}}}', helpers
	prompt: () ->
		StringTemplate.compile '{{{cmPrompt}}}', helpers
	buttonContent: () ->
		StringTemplate.compile '{{{cmButtonContent}}}', helpers

Template.autoformModals.helpers helpers

Template.autoformModals.destroyed = -> $('body').unbind 'click'

Template.afModal.rendered = ->
	$('.modal-trigger').leanModal
		ready: ->
			AutoForm.invalidateFormContext 'cmForm'
			return

Template.afModal.helpers
	classes: ->
		classes = Template.instance().data.class or ""
		array = classes.split ' '
		classes = _.union array, ['modal-trigger']
		classes.join ' '

Template.afModal.events
	'click *': (e, t) ->
		e.preventDefault()

		html = t.$('*').html()

		options = t.data
		options.title = options.title or html
		AutoForm.openModal options

AutoForm.openModal = (options) ->
	cleanSession()
	
	{
		collection,
		operation,
		fields,
		omitFields,
		title,
		doc,
		buttonContent,
		buttonClasses,
		prompt
	} = options

	Session.set 'cmCollection', options.collection
	Session.set 'cmOperation', options.operation
	Session.set 'cmFields', options.fields
	Session.set 'cmOmitFields', options.omitFields
	Session.set 'cmTitle', options.title

	if typeof options.doc == 'string'
		Session.set 'cmDoc', collectionObj(options.collection).findOne _id: options.doc
	else
		Session.set 'cmDoc', options.doc

	if options.buttonContent
		Session.set 'cmButtonContent', options.buttonContent
	else if options.operation == 'insert'
		Session.set 'cmButtonContent', 'Create'
	else if options.operation == 'update'
		Session.set 'cmButtonContent', 'Update'
	else if options.operation == 'remove'
		Session.set 'cmButtonContent', 'Delete'

	if options.buttonClasses
		Session.set 'cmButtonClasses', options.buttonClasses
	else if options.operation == 'remove'
		Session.set 'cmButtonClasses', 'waves-effect btn-flat modal-action'
	else
		Session.set 'cmButtonClasses', 'waves-effect btn-flat modal-action'

	if options.prompt
		Session.set 'cmPrompt', options.prompt
	else if options.operation == 'remove'
		Session.set 'cmPrompt', 'Are you sure?'
	else
		Session.set 'cmPrompt', ''

	$('#afModal').openModal
		ready: ->
			AutoForm.invalidateFormContext 'cmForm'
			return

AutoForm.hooks(
	cmForm :
		onSuccess: (operation, result, template)->
			$('#afModal').closeModal()
		)
