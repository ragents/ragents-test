// Generated by CoffeeScript 1.8.0
var expect, inNode, pkg, port, ports, ragents, server, shelljs, wsURL;

inNode = typeof Window === "undefined";

if (inNode) {
  expect = require("expect.js");
  shelljs = require("shelljs");
  ports = require("ports");
  ragents = require("ragents");
  pkg = require("../package.json");
  port = ports.getPort(pkg.name);
  wsURL = "ws://localhost:" + port;
  server = "node_modules/ragentsd/lib/ragentsd";
} else {
  wsURL = location.origin.replace(/^http/, "ws");
}

describe("ragents", function() {
  var serverProcess;
  serverProcess = null;
  beforeEach(function(done) {
    var cmd;
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
      url: wsURL,
      key: "0"
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
      url: wsURL,
      key: "0"
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
  it("createAgent event", function(done) {
    return ragents.createSession({
      url: wsURL,
      key: "0"
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
  return it("agent.destroyed event", function(done) {
    return ragents.createSession({
      url: wsURL,
      key: "0"
    }, function(err, session) {
      var agentInfo;
      expect(err).to.be(null);
      expect(session).not.to.eql(void 0);
      agentInfo = {
        name: "createAgent",
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
});

//# sourceMappingURL=test-basic-server.js.map