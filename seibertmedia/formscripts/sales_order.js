/**
 * TICKET: BRO-917
 *
 * FUNCTIONALITY:
 * Loads and renders the intro and outro templates of this form upon loading an entry of said form.
 * The templates need to have the naming scheme that they end in ' - Intro' respectively ' - Outro'.
 */

const formName = 'Sales Order';
const keepTemplatesCheckbox = 'keep_custom_templates';
const renderTemplatesButton = 'render_templates';
const fieldNameTemplateLanguage = 'template_language';

frappe.ui.form.on(
    formName,  // Name of the form
    {
        onload: function (frm) {
            if (frm.doc[keepTemplatesCheckbox] !== 1 && frm.doc.docstatus == 0) {  // Only if the user did not check the box
                frm.events.renderTemplate(frm);  // Directly render the template on page load
            }
        },
        after_save: function (frm) {
            if (frm.doc[keepTemplatesCheckbox] !== 1) {  // Only if the user did not check the box
                frm.events.renderTemplate(frm);  // Render the template after saving the form
            }
        },
        /**
         * Renders the intro and outro templates
         *
         * @param frm  The current form object
         */
        renderTemplate: function (frm) {
            let defaultTemplate = frm.meta.default_print_format;  // e.g. 'Sales Invoice Template'

            // Render and insert `introtext`
            frappe.call({
                method: 'frappe.www.printview.get_html_and_style',
                args: {
                    doc: frm.doc,
                    print_format: defaultTemplate + ' - Intro',
                    no_letterhead: 0,
                    _lang: frm.events.retrieveTemplateLanguage(frm),
                },
                callback: function (res) {
                    if (!res.exc) {
                        frm.set_value('introtext', res.message.html);
                    }
                }
            });

            // Render and insert `outrotext`
            frappe.call({
                method: 'frappe.www.printview.get_html_and_style',
                args: {
                    doc: frm.doc,
                    print_format: defaultTemplate + ' - Outro',
                    no_letterhead: 0,
                    _lang: frm.events.retrieveTemplateLanguage(frm),
                },
                callback: function (res) {
                    if (!res.exc) {
                        frm.set_value('outrotext', res.message.html);
                    }
                }
            });
        },
        /**
         * Retrieves the currently set language of the print preview
         *
         * @returns {String}
         */
        retrieveTemplateLanguage: function (frm) {
            let selectedLanguage = frm.doc[fieldNameTemplateLanguage];
            if (selectedLanguage === 'Deutsch') {
                return 'de';
            } else if (selectedLanguage === 'English') {
                return 'en';
            } else {
                return 'de';
            }
        }
    }
);

/**
 * Re-render the templates upon pressing the respective button
 */
frappe.ui.form.on(
    formName,  // Name of the form
    renderTemplatesButton,  // Name of the button
    function (frm) {
        frm.events.renderTemplate(frm);
    }
);

/**
 * Upon selecting a different value via the `fieldNameTemplateLanguage` 'Select' field,
 * re-render both templates.
 */
frappe.ui.form.on(
    formName,  // Name of the form
    fieldNameTemplateLanguage,  // Name of 'Select' field
    function (frm) {
        frm.events.renderTemplate(frm);
    }
);