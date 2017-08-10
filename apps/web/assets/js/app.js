import Turbolinks from 'turbolinks'
import React from 'react'
import ReactDOM from 'react-dom'
import ProgressBar from './progress-bar'
import Socket from './socket'

class App {
  constructor() {
    this.Turbolinks = Turbolinks
    this.Socket = Socket
    this.ProgressBar = ProgressBar

    this.initialize()
  }


  initialize() {
    this.Turbolinks.start()
    this.Socket.connect()
  }
}

window.App = new App()
