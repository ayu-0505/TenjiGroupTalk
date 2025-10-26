import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "button"];

  connect() {
    this.toggle();
  }

  toggle() {
    const isAllFilled = this.inputTargets.every(
      (input) => input.value.trim().length > 0
    );
    const button = this.buttonTarget;

    if (!isAllFilled) {
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
