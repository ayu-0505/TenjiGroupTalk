import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  toggle(event) {
    const value = event.target.value.trim();
    const button = this.buttonTarget;

    if (value.length === 0) {
      button.disabled = true;
      button.classList.remove("bg-blue-500");
      button.classList.add("bg-blue-300", "cursor-not-allowed");
    } else {
      button.disabled = false;
      button.classList.remove("bg-blue-300", "cursor-not-allowed");
      button.classList.add("bg-blue-500");
    }
  }
}
