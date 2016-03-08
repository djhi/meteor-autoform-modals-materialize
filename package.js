Package.describe({
    name: 'gildaspk:autoform-modals-materialize',
    summary: "Create, update and delete collections with materialize modals",
    version: "0.0.9",
    git: "https://github.com/djhi/meteor-autoform-modals-materialize",
});

Package.on_use(function(api) {
    api.versionsFrom('METEOR@1.2.0.2');

    api.use([
        'jquery',
        'templating',
        'less',
        'reactive-var',
        'coffeescript',
        'ui',
        'aldeed:autoform@5.3.0',
        'gildaspk:autoform-materialize@0.0.20',
        'raix:handlebar-helpers@0.2.4',
        'mpowaga:string-template@0.1.0',
    ], 'client');

    api.imply([
        'aldeed:autoform@5.3.0',
        'gildaspk:autoform-materialize@0.0.20',
    ]);

    api.add_files('lib/client/modals.html', 'client');
    api.add_files('lib/client/modals.coffee', 'client');
    api.add_files('lib/client/modals.less', 'client');
});
