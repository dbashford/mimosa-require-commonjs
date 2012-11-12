"use strict"

exports.defaults = ->
  requireCommonjs:
    exclude:["[/\\\\]vendor[/\\\\]", "[/\\\\]main[\\.-]"]

exports.placeholder = ->
  """
  \t

    # requireCommonjs:          # Configuration for the mimosa-require-commonjs module
      # exclude:["[/\\\\]vendor[/\\\\]", "[/\\\\]main[\\.-]"]  # List of regexes for files
                                # to exclude from wrapping in requirejs' commonjs wrapper
                                # by default anything in a vendor folder and anything
                                # that begins with 'main.' or 'main-' as presumably those
                                # are main requirejs config files and should not be wrapped
                                # in a commonjs wrapper
  """

exports.validate = (config) ->
  errors = []
  if config.requireCommonjs?
    if typeof config.requireCommonjs is "object" and not Array.isArray(config.requireCommonjs)
      if config.requireCommonjs.exclude?
        if Array.isArray(config.requireCommonjs.exclude)
          for ex in config.requireCommonjs.exclude
            unless typeof ex is "string"
              errors.push "requireCommonjs.exclude must be an array of strings"
              break
        else
          errors.push "requireCommonjs.exclude must be an array."
    else
      errors.push "requireCommonjs configuration must be an object."

  if errors.length is 0 and config.requireCommonjs.exclude?.length > 0
    config.requireCommonjs.exclude = new RegExp config.requireCommonjs.exclude.join("|"), "i"

  errors
