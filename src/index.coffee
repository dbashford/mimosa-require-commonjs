"use strict"

config = require './config'

defineRegex = /(?:(?!\.))define\(/

logger = null

registration = (mimosaConfig, register) ->
  logger = mimosaConfig.log
  register ['add','update','buildFile'], 'afterCompile', _applyCommonJSWrapper,  [mimosaConfig.extensions.javascript...]

_applyCommonJSWrapper = (mimosaConfig, options, next) ->
  hasFiles = options.files?.length > 0
  return next() unless hasFiles

  for file in options.files
    if mimosaConfig.requireCommonjs?.excludeRegex? and file.inputFileName.match mimosaConfig.requireCommonjs.excludeRegex
      logger.debug "skipping commonjs wrapping for [[ #{file.inputFileName} ]], file is excluded via regex"
    else if mimosaConfig.requireCommonjs.exclude.indexOf(file.inputFileName) > -1
      logger.debug "skipping commonjs wrapping for [[ #{file.inputFileName} ]], file is excluded via string path"
    else
      if file.outputFileText?
        if file.outputFileText.match defineRegex
          if logger.isDebug()
            logger.debug "Not wrapping [[ #{file.inputFileName} ]], it already contains a define block"
        else
          if logger.isDebug()
            logger.debug "CommonJS wrapping [[ #{file.inputFileName} ]]"

          file.outputFileText = _wrap(file.outputFileText)
  next()

_wrap = (text) ->
  """
  define(function (require, exports, module) {
    var __filename = module.uri || "", __dirname = __filename.substring(0, __filename.lastIndexOf("/") + 1);
    #{text}
  });

  """

module.exports =
  registration: registration
  defaults:     config.defaults
  placeholder:  config.placeholder
  validate:     config.validate