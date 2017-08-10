import Turbolinks from 'turbolinks'

class ProgressBar extends Turbolinks.ProgressBar {
  constructor() {
    super()

    $(document).on('ajaxStart', (event) => {
      this.setValue(0)
      this.timer = setTimeout(() => {
        this.show()
      }, 350)
    })

    $(document).on('ajaxStop', (event) => {
      this.setValue(100)
      this.hide()
      clearTimeout(this.timer)
    })
  }
}

export default new ProgressBar()
