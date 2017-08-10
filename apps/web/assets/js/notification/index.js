import React from 'react'

class Notification extends React.Component {
  constructor(props) {
    super(props)

    this.close = this.close.bind(this)
    this.state = { closed: false }
  }

  componentDidMount() {
    setTimeout(this.close, 2000)
  }

  render() {
    if (this.state.closed) return null

    return (
      <div className={this.getClassName()}>
        <button className="delete" onClick={this.close}></button>
        {this.props.message}
      </div>
    )
  }

  getClassName() {
    return `notification is-${this.props.level || 'info'}`
  }

  close() {
    this.setState({closed: true})
  }
}

export default Notification
