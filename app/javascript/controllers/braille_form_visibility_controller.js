import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"];

  switchFormVisiblity(event) {
    this.formTarget.classList.toggle("hidden", !event.target.checked);
  }
}
