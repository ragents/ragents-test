# Licensed under the Apache License. See footer for details.

inNode = typeof(Window) == "undefined"

key     = "to-be-calculated"
counter = 0

if inNode
  expect  = require "expect.js"
  shelljs = require "shelljs"
  ports   = require "ports"

  ragents = require "../../ragents"

  pkg = require "../package.json"

  port   = ports.getPort pkg.name
  url    = "ws://localhost:#{port}"
  server = "../ragents-server/lib/ragentsd"

else
  url = location.origin.replace(/^http/, "ws")

#-------------------------------------------------------------------------------
describe "event", ->


  serverProcess = null

  #-----------------------------------------------------------------------------
  before (done) ->
    return done() unless inNode

    cmd = "node #{server} --port #{port}"
    serverProcess = shelljs.exec cmd, {async:true}, (code, output) ->
      # console.log "server exited: #{code} output:\n#{output}"

    setTimeout done, 1000

  #-----------------------------------------------------------------------------
  after ->
    return unless inNode
    return unless serverProcess?

    console.log "killing ragentsd server"
    serverProcess.kill()
    serverProcess = null

  #-----------------------------------------------------------------------------
  beforeEach ->
    key = "#{Date.now()}-${counter++}"

  #-----------------------------------------------------------------------------
  afterEach ->

  #-----------------------------------------------------------------------------
  it "ping", (done) ->
    total = 0

    bodySent =
      a: 1
      b:
        c: 3
        d: 4

    ragents.createSession {url, key}, (err, session) ->

      agentInfo =
        name: "ping"
        title: "ping"

      session.createAgent agentInfo, (err, agent) ->

        session.getRemoteAgents (err, ragents) ->
          ragent = ragents[0]

          ragent.on "ping", (bodyRecv) ->
            bodyOrg = JSON.stringify bodySent
            bodyNew = JSON.stringify bodyRecv
            expect(bodyNew).to.be bodyOrg

            total++
            done() if total == 2

          ragent.on "ping", (bodyRecv) ->
            bodyOrg = JSON.stringify bodySent
            bodyNew = JSON.stringify bodyRecv
            expect(bodyNew).to.be bodyOrg

            total++
            done() if total == 2

          agent.emit "ping", bodySent

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
