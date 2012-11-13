mimosa-require-commonjs
===========

## Overview

This is a Mimosa module for wrapping browser code written in CommonJS with requirejs' simplified CommonJS wrapper.  This is an external module and does not come by default with Mimosa.

This module provides CommonJS support via RequireJS and AMD.  So if you are a fan of writing your modules in the CommonJS style, but want to use AMD in the browser and take advantage of all that RequireJS' configuration allows you, like, among other things, creating module path shortcuts and aliases, then this is the module for you.

Stated differently, this module allows you to write your AMD/RequireJS application using CommonJS.

Because this module still leverages AMD/RequireJS, when you write your browser code in CommonJS, you will still take advantage of all of the functionality provided by the `mimosa-require` module, like <a href="http://mimosajs.com/utilities.html#requirejs">path verification, and circular dependency checking</a> and <a href="http://mimosajs.com/optimization.html#require">on-the-fly optimization</a> if your entire application.

For more information regarding Mimosa, see http://mimosajs.com

## Usage

Add `'require-commonjs'` to your list of modules.  That's all!  Mimosa will install the module for you when you start up.

If you are using `"use strict"` in your code, and you are using the `mimosa-lint` module, you'll want to make sure that in your list of modules, `require-commonjs` comes before `lint`. If it comes after `mimosa-lint`, then `mimosa-lint` may complain about certain objects not being available that are provided by the `require-commonjs` module.

## Functionality

The `'require-commonjs'` module will wrap your JavaScript code with the <a href="http://requirejs.org/docs/api.html#cjsmodule">simplified CommonJS wrapper</a> that RequireJS provides.  This turns your CommonJS file into an AMD module.

The module performs this wrapping during the `afterCompile` step of the `buildFile`, `add` and `update` Mimosa workflows.  Which simply means whenever JavaScript is compiled or copied, post-compilation the wrapper is applied.  For JavaScript the wrapper is added to the raw JavaScript code before it is written, and for something like CoffeeScript, it is added to the compiled JavaScript.

The module will not wrap files that it determines are already wrapped in a `define` block.  It will also not wrap files that match the `requireCommonjs.exclude` regexes.  See config below.

## Default Config

```
requireCommonjs:
  exclude:["[/\\\\]vendor[/\\\\]", "[/\\\\]main[\\.-]"]
```

* `exclude`: an array of regexes. Files matching these regexes will not be wrapped. By default vendor scripts and `main.`/`main-` files are not wrapped. Vendor browser files often don't take kindly to being wrapped.  `main.` and `main-` are there as assumed matches for main requirejs config files.

## Example

The [AngularFunMimosaCommonJS](https://github.com/dbashford/AngularFunMimosaCommonJS) project is a working example of a project that uses Mimosa and CommonJS.  Check it out.  Hopefully it'll answer any questions you have.
