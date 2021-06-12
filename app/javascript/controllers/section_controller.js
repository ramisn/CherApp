import { Controller } from "stimulus"

export default class extends Controller {
  toggleSection() {
    const section = event.target.closest('.section')
    section.classList.toggle('is-open')
  }
}
