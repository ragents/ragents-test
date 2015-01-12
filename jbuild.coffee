# Licensed under the Apache License. See footer for details.

pkg = require("./package.json")

preReqFile = "tmp/pre-reqs-updated.txt"

#-------------------------------------------------------------------------------
tasks = defineTasks exports,
  watch: "watch for source file changes, run tests"
  test:  "run tests"
  link:  "link local modules"

WatchSpec = "tests tests/**/* #{preReqFile}"

#-------------------------------------------------------------------------------
mkdir "-p", "tmp"
"".to preReqFile

#-------------------------------------------------------------------------------
tasks.link = ->
  ln "-sf", "../ragents",  "node_modules/ragents"
  ln "-sf", "../ragentsd", "node_modules/ragentsd"

#-------------------------------------------------------------------------------
tasks.build = ->
  # nothing to do

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
  log "running tests at #{new Date()}"

tasks.test = ->
  log "running tests"

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

  mocha "#{options} #{tests}", silent:true, (code, output) ->
    console.log "test results:\n#{output}"

#-------------------------------------------------------------------------------
watchIter = ->
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
