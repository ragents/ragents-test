ragents-test - tests for ragents
================================================================================

Tests for <http://npmjs.org/package/ragents>



using ragents-test
================================================================================

You will need to have the `ragents` and `ragents-server` git repos cloned
along-side this repo.  Those repos are here:

* <https://github.com/ragents/ragents>
* <https://github.com/ragents/ragents-server>

Ensure you run `npm install` before running tests.

To run the node.js tests, run `npm run test`.  If you'd like to test
continuously, run `npm run watch`.

To run the browser tests, run `npm run watch`.  At the end of the node.js
tests, a server will be started that you can browse to, to run the tests.
The url will be something like: `http://localhost:6087/tests/www`, but with
a different port.



hacking
================================================================================

This project uses [cake](http://coffeescript.org/#cake) as it's
build tool.  To rebuild the project continuously, use the command

    npm run watch

Other `cake` commands are available (assuming you are using npm v2) with
the command

    npm run cake -- <command here>

Run `npm run cake` to see the other commands available in the `Cakefile`.



license
================================================================================

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
