'use strict';

require("./styles.scss");

var Elm = require('./Main');
var app = Elm.Main.fullscreen(localStorage.session || null);

// Stores token
app.ports.storeSession.subscribe(function(session) {
  localStorage.session = session;
});

window.addEventListener("storage", function(event) {
  if (event.storageArea === localStorage && event.key === "session") {
    app.ports.onSessionChange.send(event.newValue);
  }
}, false);
