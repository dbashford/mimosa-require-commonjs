"use strict";
var path;

path = require('path');

exports.defaults = function() {
  return {
    requireCommonjs: {
      exclude: [/[/\\]vendor[/\\]/, /[/\\]main[\.-]/]
    }
  };
};

exports.placeholder = function() {
  return "\t\n\n  requireCommonjs:          # Configuration for the mimosa-require-commonjs module\n    exclude:[/[/\\\\]vendor[/\\\\]/, /[/\\\\]main[\\.-]/]  # List of regexes or strings to match\n                            # files that should be excluded from wrapping in requirejs'\n                            # commonjs wrapper.  String paths can be absolute or relative to\n                            # the watch.javascriptDir.  Regexes are applied to the entire path.\n                            # By default anything in a vendor folder and anything that begins\n                            # with 'main.' or 'main-' are excluded as presumably those are\n                            # already wrapped or are main requirejs config files and should\n                            # not be wrapped.";
};

exports.validate = function(config, validators) {
  var errors, javascriptDir;
  errors = [];
  if (validators.ifExistsIsObject(errors, "requireCommonjs config", config.requireCommonjs)) {
    javascriptDir = path.join(config.watch.sourceDir, config.watch.javascriptDir);
    validators.ifExistsFileExcludeWithRegexAndString(errors, "requireCommonjs.exclude", config.requireCommonjs, javascriptDir);
  }
  return errors;
};
