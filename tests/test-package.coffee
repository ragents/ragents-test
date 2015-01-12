# Licensed under the Apache License. See footer for details.

expect = require "expect.js"

pkg = require "../package.json"

#-------------------------------------------------------------------------------
describe "package", ->

  #-----------------------------------------------------------------------------
  it "name should be a string", ->
    expect(pkg.name).to.be "ragents-test"

  #-----------------------------------------------------------------------------
  it "version should be a semver", ->
    expect(pkg.version).to.match /^\d+\.\d+\.\d+(.*)$/

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
