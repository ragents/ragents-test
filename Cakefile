# Licensed under the Apache License. See footer for details.

require "cakex"

ports = require "ports"

pkg = require "./package.json"

preReqFile = "tmp/pre-reqs-updated.txt"

#-------------------------------------------------------------------------------
task "watch",  "watch for source file changes, build, run tests", -> taskWatch()
task "build",  "run build",                                       -> taskBuild()
task "test",   "run tests",                                       -> taskTest()
task "link",   "link modules",                                    -> taskLink()
task "git-st", "run `git st` on projects",                        -> taskGitSt()

WatchSpec = "tests/**/* lib/**/* #{preReqFile}"

#-------------------------------------------------------------------------------
mkdir "-p", "tmp"
"".to preReqFile

#-------------------------------------------------------------------------------
taskGitSt = ->
  gitSt "../ragents"
  gitSt "../ragents-server"
  gitSt "../ragents-test"

#-------------------------------------------------------------------------------
taskBuild = ->
  cp "-f", "../ragents/www/ragents-browser.js", "tests/www"
  mkdir "-p", "tests/www/js"
  coffee "--compile --bare --output tests/www/js tests/*.coffee"

#-------------------------------------------------------------------------------
taskWatch = ->
  watchIter()

  watch
    files: WatchSpec.split " "
    run:   watchIter

  watch
    files: "Cakefile"
    run: (file) ->
      return unless file == "Cakefile"
      log "Cakefile changed, exiting"
      exit 0

#-------------------------------------------------------------------------------
watchIter = ->
  log "in #{path.relative "../..", __dirname}"

  taskBuild()
  taskTest()

#-------------------------------------------------------------------------------
taskTest = ->
  log "running tests"

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

  # process.env.DEBUG = "ragents:*"

  mocha "#{options} #{tests}"

  #mocha "#{options} #{tests}", silent:true, (code, output) ->
  #  log "test results:\n#{output}"

  # start test server for www tests
  port = ports.getPort "ragents-test-www"

  log "to run tests, browse to http://localhost:#{port}/tests/www"

  app = "lib/server"
  cmd = [app, port]

  daemon.start "server-www", "node", cmd

#-------------------------------------------------------------------------------
gitSt = (dir) ->
  currDir = pwd()
  cd dir

  log "in #{path.basename dir}"
  exec "git status"
  log()

  cd currDir

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
