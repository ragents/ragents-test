# Licensed under the Apache License. See footer for details.

expect  = require "expect.js"
shelljs = require "shelljs"

pkg = require "../package.json"

server = "node_modules/ragentsd/lib/ragentsd"
#-------------------------------------------------------------------------------
describe "package", ->

  serverProcess = null

  #-----------------------------------------------------------------------------
  before (done)->
    serverProcess = shelljs.exec "node #{server}", {async:true}, (code, output) ->
      console.log "server exited: #{code} output:\n#{output}"

    setTimeout done, 1000

  #-----------------------------------------------------------------------------
  after ->
    return unless serverProcess?

    console.log "killing server"
    serverProcess.kill()
    serverProcess = null

  #-----------------------------------------------------------------------------
  it "TBD: server tests", ->
    console.log "provide server tests"

#-------------------------------------------------------------------------------
# Copyright IBM Corp. 2014
#
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
