/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */


CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
    config.height = 600
    config.toolbarGroups = [
        {  groups: [ 'mode' ] },

        { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
        { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align'] },
        { name: 'links' },
        { name: 'insert' },
        { name: 'styles' },
        { name: 'colors' },
        { name: 'tools' },
        { name: 'others' },
        { name: 'about' }
    ]
    config.coreStyles_bold = { element: 'b', overrides: 'strong' };
    config.coreStyles_italic = { element : 'i', overrides : 'em' };
    config.autoParagraph = false;
    config.scayt_autoStartup = false;
    config.disableNativeSpellChecker = false;
    config.removePlugins = 'scayt,menubutton,contextmenu';
};
