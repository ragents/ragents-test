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
describe "basic server", ->

  serverProcess = null

  #-----------------------------------------------------------------------------
  beforeEach (done) ->
    key = "#{Date.now()}-${counter++}"

    return done() unless inNode

    cmd = "node #{server} --port #{port}"
    serverProcess = shelljs.exec cmd, {async:true}, (code, output) ->
      # console.log "server exited: #{code} output:\n#{output}"

    setTimeout done, 1000

  #-----------------------------------------------------------------------------
  afterEach ->
    return unless inNode
    return unless serverProcess?

    console.log "killing ragentsd server"
    serverProcess.kill()
    serverProcess = null

  #-----------------------------------------------------------------------------
  it "createSession", (done) ->
    ragents.createSession {url, key}, (err, session) ->

      expect(err).to.be null
      expect(session).not.to.eql undefined

      session.getRemoteAgents (err, agents) ->
        expect(err).to.be null
        expect(agents).not.to.eql undefined
        expect(agents).to.have.length 0
        done()

  #-----------------------------------------------------------------------------
  it "createAgent", (done) ->
    ragents.createSession {url, key}, (err, session) ->

      expect(err).to.be null
      expect(session).not.to.eql undefined

      agentInfo =
        name: "createAgent"
        title: "blah blah"

      session.createAgent agentInfo, (err, agent) ->
        expect(err).to.be null
        expect(agentInfo.name ).to.eql agent.info.name
        expect(agentInfo.title).to.eql agent.info.title

        session.getRemoteAgents (err, agents) ->
          expect(err).to.be null
          expect(agents).not.to.eql undefined
          expect(agents).to.have.length 1
          done()

  #-----------------------------------------------------------------------------
  it "agentCreated event", (done) ->
    ragents.createSession {url, key}, (err, session) ->

      expect(err).to.be null
      expect(session).not.to.eql undefined

      agentInfo =
        name: "createAgent"
        title: "blah blah"

      session.on "ragentCreated", (agent) ->
        expect(agentInfo.name ).to.eql agent.info.name
        expect(agentInfo.title).to.eql agent.info.title
        done()

      session.createAgent agentInfo, (err, agent) ->
        expect(err).to.be null
        expect(agentInfo.name ).to.eql agent.info.name
        expect(agentInfo.title).to.eql agent.info.title

  #-----------------------------------------------------------------------------
  it "agentDestroyed event", (done) ->
    ragents.createSession {url, key}, (err, session) ->

      expect(err).to.be null
      expect(session).not.to.eql undefined

      agentInfo =
        name: "destroyAgent"
        title: "blah blah"

      session.on "ragentDestroyed", (agent) ->
        expect(agentInfo.name ).to.eql agent.info.name
        expect(agentInfo.title).to.eql agent.info.title
        done()

      session.createAgent agentInfo, (err, agent) ->
        agent.destroy()

  #-----------------------------------------------------------------------------
  it "getRemoteAgents", (done) ->
    ragents.createSession {url, key}, (err, session) ->

      expect(err).to.be null
      expect(session).not.to.eql undefined

      agentInfo =
        name: "eventingAgent"
        title: "blah blah"

      session.createAgent agentInfo, (err, agent) ->
        session.getRemoteAgents (err, ragents) ->
          expect(ragents.length).to.eql 1

          ragentInfo = ragents[0].info

          expect(ragentInfo.name).to.eql  "eventingAgent"
          expect(ragentInfo.title).to.eql "blah blah"

          done()

  #-----------------------------------------------------------------------------
  it "serverClose", (done) ->
    ragents.createSession {url, key}, (err, session) ->

      session.on "close", ->
        done()

      unless inNode
        return done()

      serverProcess.kill()
      serverProcess = null


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
