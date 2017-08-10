import React from 'react'

class AsyncComponent extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      Component: null
    }
  }

  componentDidMount() {
    this.props.resolve().then((Component) =>
      this.setState({ Component: Component.default || Component })
    )
  }

  render() {
    const { Component } = this.state
    const { Loading, resolve, ...props } = this.props

    if (Component) {
      return <Component {...props} />
    }

    return <Loading {...props} />
  }
}

export default AsyncComponent
