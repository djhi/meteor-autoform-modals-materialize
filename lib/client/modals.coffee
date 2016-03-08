cmFormId = new ReactiveVar()
cmCollection = new ReactiveVar()
cmSchema = new ReactiveVar()
cmOperation = new ReactiveVar()
cmDoc = new ReactiveVar()
cmButtonHtml = new ReactiveVar()
cmFields = new ReactiveVar()
cmOmitFields = new ReactiveVar()
cmButtonContent = new ReactiveVar()
cmButtonCancelContent = new ReactiveVar()
cmTitle = new ReactiveVar()
cmButtonClasses = new ReactiveVar()
cmButtonSubmitClasses = new ReactiveVar()
cmButtonCancelClasses = new ReactiveVar()
cmPrompt = new ReactiveVar()
cmTemplate = new ReactiveVar()
cmLabelClass = new ReactiveVar()
cmInputColClass = new ReactiveVar()
cmPlaceholder = new ReactiveVar()
cmMeteorMethod = new ReactiveVar()

registeredAutoFormHooks = ['cmForm']

AutoForm.addHooks 'cmForm',
	onSuccess: ->
		$('#afModal').closeModal()
		return

collectionObj = (name) ->
	name.split('.').reduce (o, x) ->
		o[x]
	, window

Template.autoformModals.events
	'click button:not(.close)': () ->
		collection = cmCollection.get()
		operation = cmOperation.get()

		if operation != 'insert'
			_id = cmDoc.get()._id

		if operation == 'remove'
			collectionObj(collection).remove _id, (e) ->
				if e
					alert 'Sorry, this could not be deleted.'
				else
					$('#afModal').closeModal()
		return

	'click [data-action="submit"]': (event, template) ->
		event.preventDefault()
		template.$('form').submit()
		return

	'click [data-action="cancel"]': (event, template) ->
		event.preventDefault()
		$('#afModal').closeModal()
		return

helpers =
	cmFormId: () ->
		cmFormId.get()
	cmCollection: () ->
		cmCollection.get()
	cmSchema: () ->
		cmSchema.get()
	cmOperation: () ->
		cmOperation.get()
	cmDoc: () ->
		cmDoc.get()
	cmButtonHtml: () ->
		cmButtonHtml.get()
	cmFields: () ->
		cmFields.get()
	cmOmitFields: () ->
		cmOmitFields.get()
	cmButtonContent: () ->
		cmButtonContent.get()
	cmButtonCancelContent: () ->
		cmButtonCancelContent.get()
	cmTitle: () ->
		cmTitle.get()
	cmButtonClasses: () ->
		cmButtonClasses.get()
	cmButtonSubmitClasses: () ->
		cmButtonSubmitClasses.get()
	cmButtonCancelClasses: () ->
		cmButtonCancelClasses.get()
	cmPrompt: () ->
		cmPrompt.get()
	cmTemplate: () ->
		cmTemplate.get()
	cmLabelClass: () ->
		cmLabelClass.get()
	cmInputColClass: () ->
		cmInputColClass.get()
	cmPlaceholder: () ->
		cmPlaceholder.get()
	cmFormId: () ->
		cmFormId.get() or 'cmForm'
	cmMeteorMethod: () ->
		cmMeteorMethod.get()
	title: () ->
		StringTemplate.compile '{{{cmTitle}}}', helpers
	prompt: () ->
		StringTemplate.compile '{{{cmPrompt}}}', helpers

Template.autoformModals.helpers helpers

Template.autoformModals.destroyed = -> $('body').unbind 'click'

Template.afModal.events
	'click *': (e, t) ->
		e.preventDefault()

		html = t.$('*').html()

		formId = t.data.formId or "cmForm"
		cmFormId.set formId
		cmCollection.set t.data.collection
		cmSchema.set t.data.schema
		cmOperation.set t.data.operation
		cmFields.set t.data.fields
		cmOmitFields.set t.data.omitFields
		cmButtonHtml.set html
		cmTitle.set t.data.title or html
		cmTemplate.set t.data.template
		cmLabelClass.set t.data.labelClass
		cmInputColClass.set t.data.inputColClass
		cmPlaceholder.set if t.data.placeholder is true then 'schemaLabel' else ''
		cmMeteorMethod.set t.data.meteorMethod

		if not _.contains registeredAutoFormHooks, formId
			AutoForm.addHooks formId,
				onSuccess: ->
					$('#afModal').closeModal()
					return

			registeredAutoFormHooks.push formId

		if t.data.doc and typeof t.data.doc == 'string'
			cmDoc.set collectionObj(t.data.collection).findOne _id: t.data.doc

		if t.data.buttonContent
			cmButtonContent.set t.data.buttonContent
		else if t.data.operation == 'insert'
			cmButtonContent.set 'Create'
		else if t.data.operation == 'update' or t.data.operation is 'method-update'
			cmButtonContent.set 'Update'
		else if t.data.operation == 'remove'
			cmButtonContent.set 'Delete'

		if t.data.buttonCancelContent
			cmButtonCancelContent.set t.data.buttonCancelContent
		else
			cmButtonCancelContent.set 'Cancel'

		defaultButtonClasses = 'waves-effect btn-flat modal-action'
		if t.data.buttonClasses
			cmButtonClasses.set t.data.buttonClasses
			cmButtonCancelClasses.set t.data.buttonClasses
			cmButtonSubmitClasses.set t.data.buttonClasses
		else
			cmButtonClasses.set defaultButtonClasses
			cmButtonCancelClasses.set defaultButtonClasses
			cmButtonSubmitClasses.set defaultButtonClasses

		if t.data.buttonSubmitClasses
			cmButtonSubmitClasses.set t.data.buttonSubmitClasses
		else
			cmButtonSubmitClasses.set defaultButtonClasses

		if t.data.buttonCancelClasses
			cmButtonCancelClasses.set t.data.buttonCancelClasses
		else
			cmButtonCancelClasses.set defaultButtonClasses

		if t.data.prompt
			cmPrompt.set t.data.prompt
		else if t.data.operation == 'remove'
			cmPrompt.set 'Are you sure?'
		else
			cmPrompt.set ''

		$('#afModal').openModal
			complete: -> return

		return
