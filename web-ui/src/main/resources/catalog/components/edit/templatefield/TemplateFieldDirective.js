(function() {
  goog.provide('gn_template_field_directive');

  var module = angular.module('gn_template_field_directive', []);
  module.directive('gnTemplateFieldAddButton', ['gnEditor', 'gnCurrentEdit',
    function(gnEditor, gnCurrentEdit) {

      return {
        restrict: 'A',
        replace: true,
        scope: {
          id: '@gnTemplateFieldAddButton'
        },
        link: function(scope, element, attrs) {
          var textarea = $(element).parent()
            .find('textarea[name=' + scope.id + ']');
          // Unregister this textarea to the form
          // It will be only submitted if user click the add button
          textarea.removeAttr('name');

          scope.addFromTemplate = function() {
            textarea.attr('name', scope.id);

            // Save and refreshform
            gnEditor.save(gnCurrentEdit.id, true);
          };

          $(element).click(scope.addFromTemplate);
        }
      };
    }]),
  /**
     * The template field directive managed a custom field which
     * is based on an XML snippet to be sent in the form with some
     * string to be replace from related inputs.
     *
     * This allows to edit a complex XML structure with simple
     * form fields. eg. a date of creation where only the date field
     * is displayed to the end user and the creation codelist value
     * is in the XML template for the field.
     */
  module.directive('gnTemplateField', ['$http', '$rootScope',
    function($http, $rootScope) {

      return {
        restrict: 'A',
        replace: false,
        transclude: false,
        scope: {
          id: '@gnTemplateField',
          keys: '@',
          values: '@'
        },
        link: function(scope, element, attrs) {
          var xmlSnippetTemplate = element[0].innerHTML;
          var fields = scope.keys && scope.keys.split('#');
          var values = scope.values && scope.values.split('#');


          // Replace all occurence of {{fieldname}} by its value
          var generateSnippet = function() {
            var xmlSnippet = xmlSnippetTemplate, updated = false;
            angular.forEach(fields, function(field) {
              var value = $('#' + scope.id + '_' + field).val() || '';
              if (value !== undefined) {
                xmlSnippet = xmlSnippet.replace(
                    '{{' + field + '}}',
                    value.replace(/\&/g, '&amp;amp;')
                         .replace(/\"/g, '&quot;'));
                updated = true;
              }
            });

            // Usually when a template field is link to a
            // gnTemplateFieldAddButton directive, the keys
            // is empty.
            if (scope.keys === undefined) {
              updated = true;
            }

            // Reset the snippet if no match were found TODO
            // which means that no value is defined
            element[0].innerHTML = '';
            if (updated) {
              element[0].innerHTML = xmlSnippet;
            }
          };

          // Register change event on each fields to be
          // replaced in the XML snippet.
          angular.forEach(fields, function(value) {
            $('#' + scope.id + '_' + value).change(function() {
              generateSnippet();
            });
          });

          // Initialize all values
          angular.forEach(values, function(value, key) {
            var selector = '#' + scope.id + '_' + fields[key];
            $(selector).val(value);
          });

          generateSnippet();
        }
      };
    }]);
})();
