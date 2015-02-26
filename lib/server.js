// Licensed under the Apache License. See footer for details.

var path = require("path")
var http = require("http")

var express       = require("express")
var ragentsServer = require("ragents-server")

var app  = express()
var port = process.argv[2]

if (port == null) {
  console.log("server: required parameter port was not passed")
  process.exit()
}

app.use(express.static(path.dirname(__dirname)))

var httpServer = http.createServer(app)

console.log("server: starting on http://localhost:" + port)
httpServer.listen(port, function() {
  console.log("server: started  on http://localhost:" + port)
})

var config = {
  httpServer: httpServer
}

var rserver = ragentsServer.createServer(config)
rserver.start()

//------------------------------------------------------------------------------
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//------------------------------------------------------------------------------
