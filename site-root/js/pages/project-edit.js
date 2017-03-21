(function() {
    var $textarea = $('textarea[name=README]'),
        markdownStr = $textarea.text(),
        $readmeEditorCt = $('<div class="markdown-editor readme"></div>'),
        $hiddenInput = $('<input type="hidden" name="README">'),
        developerUrlField = $('#field-url-developers'),
        readmeSyncButton = developerUrlField.next('button'),
        readmeEditor, githubCheck, urlMatches, syncReadme;
    // replace textarea with container div and hidden input
    $textarea.replaceWith($readmeEditorCt);
    $readmeEditorCt.after($hiddenInput);

    // initialize epiceditor
    readmeEditor = new EpicEditor({
        container: $readmeEditorCt.get(0),
        autogrow: true,
        basePath: '/lib/epiceditor',
        theme: {
            preview: '/themes/preview/cfa.css'
        }
    });

    readmeEditor.load(function() {
        readmeEditor.importFile('README', markdownStr);
    });

    $hiddenInput.closest('form').submit(function(event) {
        $hiddenInput.val(readmeEditor.exportFile());
    });
    
    githubCheck = function () {
        urlMatches = /github\.com\/(.+)\/(.+)[\/]*/.exec(developerUrlField.val());

        if (!urlMatches) {
            checkingUrl = false;
            developerUrlField.removeClass('git-url');
            readmeSyncButton.removeClass('active');
            return;
        }
        
        developerUrlField.addClass('git-url');
        readmeSyncButton.addClass('active');
        checkingUrl = false; 
    };
    
    syncReadme = function () {
        $.ajax({
            url: 'http://api.github.com/repos/' + urlMatches[1] + '/' + urlMatches[2] + '/readme',
            success: function (data) {
                readmeEditor.importFile('README', atob(data.content));
                $('#syncReadmeModal').modal('hide');
            }
        });   
    };
    
    developerUrlField.on('blur', githubCheck);
    developerUrlField.on('keyup', githubCheck);
    
    $('#syncReadmeModal button.btn-primary').on('click', function () {
        syncReadme();
    });
    
    
})();