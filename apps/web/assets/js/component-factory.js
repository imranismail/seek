import React from 'react'
import AsyncComponent from './async-component'

class ComponentFactory {
  availableComponents = {
    Notification: (props) =>
      <AsyncComponent
        resolve={() => import('./notification')}
        Loading={() => <span className="loader is-large" style={{margin: 'auto'}} />}
        {...props}
      />,
    SearchInput: (props) =>
      <AsyncComponent
        resolve={() => import('./search-input')}
        Loading={() => <span className="loader is-large" style={{margin: 'auto'}} />}
        {...props}
      />,
  }

  build = (name) => {
    if (this.availableComponents[name]) {
      return this.availableComponents[name]
    } else {
      throw `Couldn't find component ${name}, available components: { ${Object.keys(this.availableComponents).join(', ')} }`
    }
  }
}

export default new ComponentFactory()
