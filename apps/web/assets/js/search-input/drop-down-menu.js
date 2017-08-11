import React from 'react'
import classNames from 'classnames'

class DropDownItem extends React.Component {
  constructor(props) {
    super(props)

    this.onMouseDown = this.onMouseDown.bind(this)
  }

  onMouseDown(event) {
    this.props.onSelect(this.props.index)
    event.preventDefault()
  }

  render() {
    return (
      <a
        href="javascript:void(0)"
        className={classNames({
          'dropdown-item': true,
          'is-active': this.props.isActive
        })}
        onMouseDown={this.onMouseDown}
      >
        {this.props.children}
      </a>
    )
  }
}

class DropDownMenu extends React.Component {
  render() {
    return (
      <div
        className={classNames({
          'dropdown-menu': true,
          'is-display-block': this.props.isShowing
        })}
      >
        <div className="dropdown-content">
          {
            this.props.options.map(({label}, i) =>
              <DropDownItem
                key={i}
                index={i}
                isActive={this.props.hightlighted === i}
                onSelect={this.props.onSelect}
              >
                {label}
              </DropDownItem>
            )
          }
        </div>
      </div>
    )
  }
}

export default DropDownMenu
