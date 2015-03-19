// Generated by CoffeeScript 1.8.0
var counter, expect, inNode, key, pkg, port, ports, ragents, server, shelljs, url;

inNode = typeof Window === "undefined";

key = "to-be-calculated";

counter = 0;

if (inNode) {
  expect = require("expect.js");
  shelljs = require("shelljs");
  ports = require("ports");
  ragents = require("ragents");
  pkg = require("../package.json");
  port = ports.getPort(pkg.name);
  url = "ws://localhost:" + port;
  server = "node_modules/ragents-server/lib/ragentsd";
} else {
  url = location.origin.replace(/^http/, "ws");
}

describe("basic server", function() {
  var serverProcess;
  serverProcess = null;
  beforeEach(function(done) {
    var cmd;
    key = "" + (Date.now()) + "-${counter++}";
    if (!inNode) {
      return done();
    }
    cmd = "node " + server + " --port " + port;
    serverProcess = shelljs.exec(cmd, {
      async: true
    }, function(code, output) {});
    return setTimeout(done, 1000);
  });
  afterEach(function() {
    if (!inNode) {
      return;
    }
    if (serverProcess == null) {
      return;
    }
    console.log("killing ragentsd server");
    serverProcess.kill();
    return serverProcess = null;
  });
  it("createSession", function(done) {
    return ragents.createSession({
      url: url,
      key: key
    }, function(err, session) {
      expect(err).to.be(null);
      expect(session).not.to.eql(void 0);
      return session.getRemoteAgents(function(err, agents) {
        expect(err).to.be(null);
        expect(agents).not.to.eql(void 0);
        expect(agents).to.have.length(0);
        return done();
      });
    });
  });
  it("createAgent", function(done) {
    return ragents.createSession({
      url: url,
      key: key
    }, function(err, session) {
      var agentInfo;
      expect(err).to.be(null);
      expect(session).not.to.eql(void 0);
      agentInfo = {
        name: "createAgent",
        title: "blah blah"
      };
      return session.createAgent(agentInfo, function(err, agent) {
        expect(err).to.be(null);
        expect(agentInfo.name).to.eql(agent.info.name);
        expect(agentInfo.title).to.eql(agent.info.title);
        return session.getRemoteAgents(function(err, agents) {
          expect(err).to.be(null);
          expect(agents).not.to.eql(void 0);
          expect(agents).to.have.length(1);
          return done();
        });
      });
    });
  });
  it("agentCreated event", function(done) {
    return ragents.createSession({
      url: url,
      key: key
    }, function(err, session) {
      var agentInfo;
      expect(err).to.be(null);
      expect(session).not.to.eql(void 0);
      agentInfo = {
        name: "createAgent",
        title: "blah blah"
      };
      session.on("agentCreated", function(agent) {
        expect(agentInfo.name).to.eql(agent.info.name);
        expect(agentInfo.title).to.eql(agent.info.title);
        return done();
      });
      return session.createAgent(agentInfo, function(err, agent) {
        expect(err).to.be(null);
        expect(agentInfo.name).to.eql(agent.info.name);
        return expect(agentInfo.title).to.eql(agent.info.title);
      });
    });
  });
  it("agentDestroyed event", function(done) {
    return ragents.createSession({
      url: url,
      key: key
    }, function(err, session) {
      var agentInfo;
      expect(err).to.be(null);
      expect(session).not.to.eql(void 0);
      agentInfo = {
        name: "destroyAgent",
        title: "blah blah"
      };
      session.on("agentDestroyed", function(agent) {
        expect(agentInfo.name).to.eql(agent.info.name);
        expect(agentInfo.title).to.eql(agent.info.title);
        return done();
      });
      return session.createAgent(agentInfo, function(err, agent) {
        return agent.destroy();
      });
    });
  });
  it("getRemoteAgents", function(done) {
    return ragents.createSession({
      url: url,
      key: key
    }, function(err, session) {
      var agentInfo;
      expect(err).to.be(null);
      expect(session).not.to.eql(void 0);
      agentInfo = {
        name: "eventingAgent",
        title: "blah blah"
      };
      return session.createAgent(agentInfo, function(err, agent) {
        return session.getRemoteAgents(function(err, ragents) {
          var ragentInfo;
          expect(ragents.length).to.eql(1);
          ragentInfo = ragents[0].info;
          expect(ragentInfo.name).to.eql("eventingAgent");
          expect(ragentInfo.title).to.eql("blah blah");
          return done();
        });
      });
    });
  });
  return it("serverClose", function(done) {
    return ragents.createSession({
      url: url,
      key: key
    }, function(err, session) {
      session.on("close", function() {
        return done();
      });
      if (!inNode) {
        return done();
      }
      serverProcess.kill();
      return serverProcess = null;
    });
  });
});
