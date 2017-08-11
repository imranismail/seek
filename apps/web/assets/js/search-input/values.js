import React from 'react'
import classNames from 'classnames'

class Value extends React.Component {
  constructor(props) {
    super(props)

    this.handleOnClick = this.handleOnClick.bind(this)
  }

  handleOnClick(event) {
    this.props.onRemove(this.props.index)
    event.preventDefault()
  }

  render() {
    return (
      <span className="tag">
        <input
          type="hidden"
          name={this.props.name}
          value={this.props.value}
        />
        {this.props.children}
        <button
          className="delete is-small"
          onClick={this.handleOnClick}
        />
      </span>
    )
  }
}

class Values extends React.Component {
  render() {
    return (
      <div
        className={classNames({
          'tags': true,
          'is-hidden': !this.props.isShowing,
        })}
      >
        {
          this.props.values.map(({value, label}, i) =>
            <Value
              key={i}
              index={i}
              value={value}
              name={this.props.name}
              onRemove={this.props.onRemove}
            >
              {label}
            </Value>
          )
        }
        {this.props.children}
      </div>
    )
  }
}

export default Values
