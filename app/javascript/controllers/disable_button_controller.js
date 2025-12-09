import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["blueInput", "blueBtn", "whiteInput", "whiteBtn"];

  connect() {
    this.blueBtnToggle();
    this.whiteBtnToggle();
  }

  blueBtnToggle() {
    if (!this.hasBlueBtnTarget) return;

    const button = this.blueBtnTarget;
    const isAllFilled = this.blueInputTargets.every(
      (input) => input.value.trim().length > 0
    );
    if (!isAllFilled) {
      button.disabled = true;
      button.classList.remove("text-white");
      button.classList.add(
        "text-blue-200",
        "hover:bg-blue-500",
        "cursor-not-allowed"
      );
    } else {
      button.disabled = false;
      button.classList.remove(
        "text-blue-200",
        "hover:bg-blue-500",
        "cursor-not-allowed"
      );
      button.classList.add("text-white");
    }
  }

  whiteBtnToggle() {
    if (!this.hasWhiteBtnTarget) return;

    const button = this.whiteBtnTarget;
    const isFilled = this.whiteInputTarget.value.trim().length > 0;
    if (!isFilled) {
      button.disabled = true;
      button.classList.remove("text-blue-700");
      button.classList.remove("border-blue-500");
      button.classList.add(
        "text-blue-300",
        "bg-gray-200",
        "border-blue-300",
        "hover:text-blue-300",
        "hover:bg-gray-200",
        "hover:border-blue-300",
        "cursor-not-allowed"
      );
    } else {
      button.disabled = false;
      button.classList.remove(
        "text-blue-300",
        "bg-gray-200",
        "border-blue-300",
        "hover:text-blue-300",
        "hover:bg-gray-200",
        "hover:border-blue-300",
        "cursor-not-allowed"
      );
      button.classList.add("text-blue-700");
    }
  }
}
