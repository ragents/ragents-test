# Licensed under the Apache License. See footer for details.

path = require "path"

ports   = require "ports"
shelljs = require "shelljs"

pkg = require "./package.json"

preReqFile = "tmp/pre-reqs-updated.txt"

#-------------------------------------------------------------------------------
tasks = defineTasks exports,
  watch:     "watch for source file changes, build, run tests"
  build:     "run build"
  test:      "run tests"
  link:      "link local modules"

WatchSpec = "tests tests/**/* #{preReqFile}"

#-------------------------------------------------------------------------------
mkdir "-p", "tmp"
"".to preReqFile

#-------------------------------------------------------------------------------
tasks.link = ->
  rm "-rF",                "node_modules/ragents"
  ln "-sf", "../ragents",  "node_modules/ragents"

  rm "-rF",                "node_modules/ragentsd"
  ln "-sf", "../ragentsd", "node_modules/ragentsd"

#-------------------------------------------------------------------------------
tasks.build = ->
  mkdir "-p", "tests/www/js"
  coffee "--compile --bare --output tests/www/js --map tests/*.coffee"

#-------------------------------------------------------------------------------
tasks.watch = ->
  watchIter()

  watch
    files: WatchSpec.split " "
    run:   watchIter

  watchFiles "jbuild.coffee" :->
    log "jbuild file changed; exiting"
    process.exit 0

#-------------------------------------------------------------------------------
tasks.test = ->
  log "running tests"

  # start test server for www tests
  port = ports.getPort "ragents-test-www"

  log "to run tests, browse to http://localhost:#{port}/tests/www"

  app = "node_modules/ragentsd/lib/ragentsd"
  cmd = [app, "--port", port, "--www", "."]

  server.start "tmp/server-www.pid", "node", cmd

  # run node tests
  tests = "tests/test-*.coffee"

  options =
    ui:         "bdd"
    reporter:   "spec"
    slow:       300
    compilers:  "coffee:coffee-script"
    require:    "coffee-script/register"

  options = for key, val of options
    "--#{key} #{val}"

  options = options.join " "

  if true
    mocha "#{options} #{tests}", silent:true, (code, output) ->
      console.log "test results:\n#{output}"

  else
    node_debug "mocha #{options} #{tests}", silent:true, (code, output) ->
      console.log "test results:\n#{output}"

#-------------------------------------------------------------------------------
watchIter = ->
  log "in #{path.relative "../..", __dirname}"

  tasks.build()
  tasks.test()

#-------------------------------------------------------------------------------
cleanDir = (dir) ->
  mkdir "-p", dir
  rm "-rf", "#{dir}/*"

#-------------------------------------------------------------------------------
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------
