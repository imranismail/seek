import './standard'
import Turbolinks from 'turbolinks'
import React from 'react'
import ReactDOM from 'react-dom'
import ComponentFactory from './component-factory'
import ProgressBar from './progress-bar'
import Socket from './socket'

class App {
  constructor() {
    this.Turbolinks = Turbolinks
    this.Socket = Socket
    this.ProgressBar = ProgressBar
    this.ComponentFactory = ComponentFactory

    this.initialize()
  }

  mountComponentAtNode = (node) => {
    const target = $(node)
    const props = target.data('props')
    const name = target.data('component')
    const Component = this.ComponentFactory.build(name)

    ReactDOM.render(<Component {...props} />, node)
  }

  mountComponents = () => {
    $('[data-component]').each((i, node) =>
      this.mountComponentAtNode(node)
    )
  }

  unmountComponents = () => {
    $('[data-component]').each((i, node) =>
      ReactDOM.unmountComponentAtNode(node)
    )
  }

  initialize() {
    this.Turbolinks.start()
    this.Socket.connect()

    $(document).on('DOMContentLoaded turbolinks:render', this.mountComponents)
    $(document).on('turbolinks:before-render', this.unmountComponents)
  }
}

window.App = new App()
