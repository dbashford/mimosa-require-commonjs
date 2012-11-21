"use strict"

path = require 'path'

windowsDrive = /^[A-Za-z]:\\/

exports.defaults = ->
  requireCommonjs:
    exclude:[/[/\\]vendor[/\\]/, /[/\\]main[\.-]/]

exports.placeholder = ->
  """
  \t

    # requireCommonjs:          # Configuration for the mimosa-require-commonjs module
      # exclude:[/[/\\]vendor[/\\]/, /[/\\]main[\.-]/]  # List of regexes or strings to match
                                # files that should be excluded from wrapping in requirejs'
                                # commonjs wrapper.  String paths can be absolute or relative to
                                # the watch.javascriptDir.  Regexes are applied to the entire path.
                                # By default anything in a vendor folder and anything that begins
                                # with 'main.' or 'main-' are excluded as presumably those are
                                # already wrapped or are main requirejs config files and should
                                # not be wrapped.
  """

exports.validate = (config) ->
  errors = []
  if config.requireCommonjs?
    if typeof config.requireCommonjs is "object" and not Array.isArray(config.requireCommonjs)
      if config.requireCommonjs.exclude?
        if Array.isArray(config.requireCommonjs.exclude)
          regexes = []
          newExclude = []
          for exclude in config.requireCommonjs.exclude
            if typeof exclude is "string"
              newExclude.push __determinePath exclude, config.watch.compiledJavascriptDir
            else if exclude instanceof RegExp
              regexes.push exclude.source
            else
              errors.push "requireCommonjs.exclude must be an array of strings and/or regexes."
              break

          if regexes.length > 0
            config.requireCommonjs.excludeRegex = new RegExp regexes.join("|"), "i"

          config.requireCommonjs.exclude = newExclude
        else
          errors.push "requireCommonjs.exclude must be an array."
    else
      errors.push "requireCommonjs configuration must be an object."

  if errors.length is 0 and config.requireCommonjs.exclude?.length > 0
    config.requireCommonjs.exclude = new RegExp config.requireCommonjs.exclude.join("|"), "i"

  errors

__determinePath = (thePath, relativeTo) ->
  return thePath if windowsDrive.test thePath
  return thePath if thePath.indexOf("/") is 0
  path.join relativeTo, thePath
