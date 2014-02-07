"use strict";
var config, defineRegex, logger, registration, _applyCommonJSWrapper, _wrap,
  __slice = [].slice;

config = require('./config');

defineRegex = /(?:(?!\.))define\(/;

logger = null;

registration = function(mimosaConfig, register) {
  logger = mimosaConfig.log;
  return register(['add', 'update', 'buildFile'], 'afterCompile', _applyCommonJSWrapper, __slice.call(mimosaConfig.extensions.javascript));
};

_applyCommonJSWrapper = function(mimosaConfig, options, next) {
  var file, hasFiles, _i, _len, _ref, _ref1, _ref2;
  hasFiles = ((_ref = options.files) != null ? _ref.length : void 0) > 0;
  if (!hasFiles) {
    return next();
  }
  _ref1 = options.files;
  for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
    file = _ref1[_i];
    if ((((_ref2 = mimosaConfig.requireCommonjs) != null ? _ref2.excludeRegex : void 0) != null) && file.inputFileName.match(mimosaConfig.requireCommonjs.excludeRegex)) {
      logger.debug("skipping commonjs wrapping for [[ " + file.inputFileName + " ]], file is excluded via regex");
    } else if (mimosaConfig.requireCommonjs.exclude.indexOf(file.inputFileName) > -1) {
      logger.debug("skipping commonjs wrapping for [[ " + file.inputFileName + " ]], file is excluded via string path");
    } else {
      if (file.outputFileText != null) {
        if (file.outputFileText.match(defineRegex)) {
          if (logger.isDebug()) {
            logger.debug("Not wrapping [[ " + file.inputFileName + " ]], it already contains a define block");
          }
        } else {
          if (logger.isDebug()) {
            logger.debug("CommonJS wrapping [[ " + file.inputFileName + " ]]");
          }
          file.outputFileText = _wrap(file.outputFileText);
        }
      }
    }
  }
  return next();
};

_wrap = function(text) {
  return "define(function (require, exports, module) {\n  var __filename = module.uri || \"\", __dirname = __filename.substring(0, __filename.lastIndexOf(\"/\") + 1);\n  " + text + "\n});\n";
};

module.exports = {
  registration: registration,
  defaults: config.defaults,
  placeholder: config.placeholder,
  validate: config.validate
};
