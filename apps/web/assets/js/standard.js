import ReactDOM from 'react-dom'

if (!Array.prototype.last) {
  Array.prototype.last = function() { return this[this.length - 1] }
}

if (!Array.prototype.first) {
  Array.prototype.first = function() { return this[0] }
}

if (!Array.prototype.isEmpty) {
  Array.prototype.isEmpty = function() { return this.length < 1 }
}

if (!Array.prototype.excludes) {
  Array.prototype.excludes = function(item) { return !this.includes(item) }
}

if (jQuery.prototype.remove) {
  jQuery.prototype.remove = ((remove) => function() {
    this.find('[data-component]').each((i, node) => ReactDOM.unmountComponentAtNode(node))
    return remove.apply(this, arguments)
  })(jQuery.prototype.remove)
}

if (jQuery.prototype.empty) {
  jQuery.prototype.empty = ((empty) => function() {
    this.find('[data-component]').each((i, node) => ReactDOM.unmountComponentAtNode(node))
    return empty.apply(this, arguments)
  })(jQuery.prototype.empty)
}

if (jQuery.prototype.replaceWith) {
  jQuery.prototype.replaceWith = ((replaceWith) => function() {
    this.find('[data-component]').each((i, node) => ReactDOM.unmountComponentAtNode(node))
    return replaceWith.apply(this, arguments)
  })(jQuery.prototype.replaceWith)
}

if (jQuery.prototype.html) {
  jQuery.prototype.html = ((html) => function() {
    const result = html.apply(this, arguments)

    if (!this.find('[data-component]').isEmpty()) {
      this.trigger('seek:mount')
    }

    return result
  })(jQuery.prototype.html)
}

if (jQuery.prototype.append) {
  jQuery.prototype.append = ((append) => function() {
    const result = append.apply(this, arguments)

    if (!this.find('[data-component]').isEmpty()) {
      this.trigger('seek:mount')
    }

    return result
  })(jQuery.prototype.append)
}

if (!jQuery.prototype.isEmpty) {
  jQuery.prototype.isEmpty = function() {
    return this.length === 0
  }
}
