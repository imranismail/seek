import React from 'react'
import classNames from 'classnames'

class SearchInput extends React.Component {
  constructor(props) {
    super(props)

    this.handleContainerClick = this.handleContainerClick.bind(this)
    this.handleOptionMouseDown = this.handleOptionMouseDown.bind(this)
    this.handleContainerBlur = this.handleContainerBlur.bind(this)
    this.handleKeyDown = this.handleKeyDown.bind(this)
    this.handleKeyUp = this.handleKeyUp.bind(this)
    this.handleInput = this.handleInput.bind(this)
    this.handleChange = this.handleChange.bind(this)
    this.setInput = this.setInput.bind(this)
    this.setContainer = this.setContainer.bind(this)

    this.state = {
      input: '',
      size: 1,
      values: [],
      options: [],
      highlighted: 0,
      focused: false,
    }
  }

  setInput(ref) {
    this.input = $(ref)
  }

  setContainer(ref) {
    this.container = $(ref)
  }

  handleOptionMouseDown(event, option) {
    this.setState(prevState => ({
      values: [...prevState.values, option]
    }))
  }

  handleKeyUp(event) {
    if (!['ArrowDown', 'ArrowUp', 'Enter'].includes(event.key)) {
      $.get(this.props.source, {
        filter: {
          query: event.target.value,
          exclude: this.state.values.map(({value}) => value),
          schema: 'option'
        }
      }).then((options) =>
        this.setState({ options })
      )
    }
  }

  handleKeyDown(event) {
    if (event.key === 'ArrowDown') {
      this.setState(prevState => {
        const nextStep = prevState.highlighted + 1
        const firstStep = 0
        const lastStep = prevState.options.length - 1
        return {
          highlighted: nextStep > lastStep ? firstStep : nextStep
        }
      })

      event.preventDefault()
    }

    if (event.key === 'ArrowUp') {
      this.setState(prevState => {
        const nextStep = prevState.highlighted - 1
        const firstStep = 0
        const lastStep = prevState.options.length - 1
        return {
          highlighted: nextStep < firstStep ? lastStep : nextStep
        }
      })

      event.preventDefault()
    }

    if (event.key === 'Enter') {
      if (this.state.options[this.state.highlighted]) {
        this.setState(prevState => ({
          input: '',
          size: 1,
          values: [...prevState.values, prevState.options[prevState.highlighted]],
          options: [],
        }))
      } else {
        this.setState({
          input: '',
          size: 1,
        })
      }
    }

    if (
      event.key === 'Backspace' &&
      event.target.value.length < 1 &&
      this.state.values.length > 0
    ) {
      this.setState(prevState => ({
        values: prevState.values.slice(0, -1)
      }))
    }
  }

  handleInput(event) {
    const currentSize = this.state.size
    const currentLength = this.input.val().length
    const inputWidth = this.input.outerWidth()
    const containerWidth = this.container.outerWidth()

    if (currentLength < 1 && currentSize > 1) {
      return this.setState({size: 1})
    }

    if (inputWidth < containerWidth) {
      return this.setState({size: currentLength})
    }
  }

  handleChange(event) {
    const value = event.target.value
    this.setState({input: value});
  }

  handleContainerClick(event) {
    this.setState({focused: true})
  }

  handleContainerBlur(event) {
    $.get(this.props.source, {
      filter: {
        query: '',
        exclude: this.state.values.map(({value}) => value),
        schema: 'option'
      }
    }).then((options) =>
      this.setState({ input: '', focused: false, options })
    )
  }

  componentDidUpdate(prevProps, prevState) {
    if (this.state.focused) this.input.focus()
  }

  componentDidMount() {
    $.get(this.props.source, {
      filter: {
        query: '',
        exclude: this.state.values.map(({value}) => value),
        schema: 'option'
      }
    }).then((options) =>
      this.setState({ options })
    )
  }

  render() {
    return (
      <div className="input is-search is-fullwidth" onClick={this.handleContainerClick} onBlur={this.handleContainerBlur}>
        <span
          className={
            classNames({
              'is-hidden': this.state.focused || this.state.values.length,
              'has-text-grey': true
            })
          }
        >
          {this.props.placeholder}
        </span>
        <div
          className={
            classNames({
              'dropdown-menu': true,
              'is-display-block': this.state.options.length > 0 && this.state.focused
            })
          }
        >
          <div className="dropdown-content">
            {
              this.state.options.map(({label, value}, i) =>
                <a
                  href="javascript:void(0)"
                  key={value}
                  className={
                    classNames({
                      'dropdown-item': true,
                      'is-active': i === this.state.highlighted
                    })
                  }
                  onMouseDown={(event) => this.handleOptionMouseDown(event, {label, value})}
                >
                  {label}
                </a>
              )
            }
          </div>
        </div>
        <div
          ref={this.setContainer}
          className={
            classNames({
              tags: true,
              'is-hidden': !this.state.focused && !this.state.values.length
            })
          }
        >
          {
            this.state.values.map(({label, value}, i) =>
              <span key={i} className="tag">
                <input
                  type="hidden"
                  name={this.props.name.replace('${i}', i)}
                  value={value}
                />
                {label}
              </span>
            )
          }
          <input
            type="text"
            ref={this.setInput}
            onInput={this.handleInput}
            onChange={this.handleChange}
            onKeyDown={this.handleKeyDown}
            onKeyUp={this.handleKeyUp}
            size={this.state.size}
            value={this.state.input}
            className="actual-input"
          />
        </div>
      </div>
    )
  }
}

export default SearchInput
