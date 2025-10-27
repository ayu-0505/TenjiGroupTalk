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
      button.classList.remove("text-white");
      button.classList.add("text-blue-200", "cursor-not-allowed");
    } else {
      button.disabled = false;
      button.classList.remove("text-blue-200", "cursor-not-allowed");
      button.classList.add("btext-white");
    }
  }
}
