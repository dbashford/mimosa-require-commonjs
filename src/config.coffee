"use strict"

path = require 'path'

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

exports.validate = (config, validators) ->
  errors = []

  if validators.ifExistsIsObject(errors, "requireCommonjs config", config.requireCommonjs)
    javascriptDir = path.join config.watch.sourceDir, config.watch.javascriptDir
    validators.ifExistsFileExcludeWithRegexAndString(errors, "requireCommonjs.exclude", config.requireCommonjs, javascriptDir)

  errors
