# Licensed under the Apache License. See footer for details.

expect  = require "expect.js"
shelljs = require "shelljs"
ports   = require "ports"

ragents = require "ragents"

pkg = require "../package.json"

port   = ports.getPort pkg.name
wsURL  = "ws://localhost:#{port}"
server = "node_modules/ragentsd/lib/ragentsd"

#-------------------------------------------------------------------------------
describe "ragents", ->

  serverProcess = null

  #-----------------------------------------------------------------------------
  beforeEach (done)->
    cmd = "node #{server} --port #{port}"
    serverProcess = shelljs.exec cmd, {async:true}, (code, output) ->
      console.log "server exited: #{code} output:\n#{output}"

    setTimeout done, 1000

  #-----------------------------------------------------------------------------
  afterEach ->
    return unless serverProcess?

    console.log "killing server"
    serverProcess.kill()
    serverProcess = null

  #-----------------------------------------------------------------------------
  it "createSession", (done) ->
    ragents.createSession {url: wsURL, key: "0"}, (err, session) ->

      expect(err).to.be null
      expect(session).not.to.eql undefined

      session.getRemoteAgents (err, agents) ->
        console.log "getRemoteAgents() returned"
        expect(err).to.be null
        expect(agents).not.to.eql undefined
        expect(agents).to.have.length 0
        console.log "really, zero ragents!"
        done()

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
