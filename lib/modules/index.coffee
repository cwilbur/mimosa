_ = require 'lodash'

compilers = require './compilers'
file =      require './file'
logger =    require 'mimosa-logger'
all = [file, compilers, logger]

pack =      require('../../package.json')

ignore = ['mimosa-logger']
builtIns = ['mimosa-server','mimosa-lint','mimosa-require','mimosa-minify']

meta = []

discoverModules = ->
  for dep, version of pack.dependencies when dep.indexOf('mimosa-') > -1
    continue if ignore.indexOf(dep) > -1
    modPack = require("../../node_modules/#{dep}/package.json")
    meta.push
      name:    dep
      version: modPack.version
      site:    modPack.homepage
      desc:    modPack.description
      default: builtIns.indexOf(dep) > -1
      dependencies: modPack.dependencies
    all.push(require dep)

discoverModules()

module.exports =
  all: all
  basic: [file, compilers]
  installedMetadata: meta
