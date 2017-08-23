import React from 'react'
import classNames from 'classnames'
import Values from './values'
import DropDownMenu from './drop-down-menu'

class Input extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      values: [],
      options: [],
      highlighted: 0,
      size: 1,
      input: '',
      focused: false,
    }

    this.handleKeyDown = this.handleKeyDown.bind(this)
    this.handleKeyUp = this.handleKeyUp.bind(this)
    this.handleInput = this.handleInput.bind(this)
    this.handleChange = this.handleChange.bind(this)
    this.handleBlur = this.handleBlur.bind(this)
    this.handleRemoveValue = this.handleRemoveValue.bind(this)
    this.onSelect = this.onSelect.bind(this)
    this.setInput = this.setInput.bind(this)
    this.handleContainerClick = this.handleContainerClick.bind(this)
  }

  onStepDown() {
    this.setState(prevState => {
      const firstStep = 0
      const nextStep = prevState.highlighted + 1
      const lastStep = prevState.options.length - 1
      return {
        highlighted: nextStep > lastStep ? firstStep : nextStep
      }
    })
  }

  onStepUp() {
    this.setState(prevState => {
      const firstStep = 0
      const nextStep = prevState.highlighted - 1
      const lastStep = prevState.options.length - 1
      return {
        highlighted: nextStep < firstStep ? lastStep : nextStep
      }
    })
  }

  onSelect(index) {
    const selected = this.state.options[index]

    if (selected) {
      this.setState(prevState => ({
        input: '',
        size: 1,
        values: [...prevState.values, selected],
        options: [],
      }))
    } else {
      this.setState({
        input: '',
        size: 1,
        options: [],
      })
    }
  }

  onSearch(query) {
    $.get(this.props.source, {
      filter: {
        query: query,
        exclude: this.state.values.map(({value}) => value),
        schema: 'option'
      }
    })
    .then(options => {
      this.setState({options})
    })
  }

  onRemoveLastValue() {
    if (this.state.values.length > 0) {
      this.setState(prevState => ({
        values: prevState.values.slice(0, -1)
      }))
    }
  }

  handleRemoveValue(index) {
    this.setState(prevState => ({
      values: prevState.values.filter((val, i) => i !== index)
    }))
  }

  handleKeyDown(event) {
    switch (event.key) {
      case 'ArrowDown':
        this.onStepDown()
        event.preventDefault()
        break
      case 'ArrowUp':
        this.onStepUp()
        event.preventDefault()
        break
      case 'Enter':
        this.onSelect(this.state.highlighted)
        event.preventDefault()
        break
      case 'Backspace':
        if (event.target.value.length < 1) this.onRemoveLastValue()
        break
    }
  }

  handleKeyUp(event) {
    if (!['ArrowDown', 'ArrowUp', 'Enter'].includes(event.key)) {
      this.onSearch(event.target.value)
    }
  }

  handleInput(event) {
    const currentSize = this.state.size
    const container = this.input.parent()
    const currentLength = this.input.val().length
    const inputWidth = this.input.outerWidth()
    const containerWidth = container.outerWidth()

    if (currentLength < 1 && currentSize > 1) {
      return this.setState({size: 1})
    }

    if (inputWidth < containerWidth) {
      return this.setState({size: currentLength})
    }
  }

  handleChange(event) {
    this.setState({input: event.target.value});
  }

  handleContainerClick(event) {
    this.setState({focused: true})
    const container = $(event.target)
    container.children('.actual-input').focus()
  }

  handleBlur(event) {
    this.setState({input: '', focused: false, options: [], size: 1})
  }

  setInput(ref) {
    this.input = $(ref)
  }

  componentDidUpdate(prevProps, prevState) {
    if (this.state.focused) this.input.focus()
    if (!prevState.focused && this.state.focused) this.onSearch('')
  }

  componentDidMount() {
    this.setState({values: this.props.values})
  }

  render() {
    return (
      <div className="input is-search is-fullwidth" onClick={this.handleContainerClick}>
        <span
          className={classNames({
            'is-hidden': this.state.focused || this.state.values.length,
            'has-text-grey': true
          })}
        >
          {this.props.placeholder}
        </span>
        <Values
          values={this.state.values}
          name={this.props.name}
          onRemove={this.handleRemoveValue}
          isShowing={this.state.focused || this.state.values.length}
        >
          <input
            type="text"
            onKeyDown={this.handleKeyDown}
            onKeyUp={this.handleKeyUp}
            onInput={this.handleInput}
            onChange={this.handleChange}
            onBlur={this.handleBlur}
            size={this.state.size}
            value={this.state.input}
            ref={this.setInput}
            className="actual-input"
          />
        </Values>
        <DropDownMenu
          options={this.state.options}
          highlighted={this.state.highlighted}
          onSelect={this.onSelect}
          isShowing={this.state.options.length > 0 && this.state.focused}
        />
      </div>
    )
  }
}

export default Input
