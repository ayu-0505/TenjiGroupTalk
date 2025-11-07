import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["blueInput", "buleBtn"];

  connect() {
    this.blueBtnToggle();
  }

  blueBtnToggle() {
    const isAllFilled = this.blueInputTargets.every(
      (input) => input.value.trim().length > 0
    );
    const button = this.buleBtnTarget;

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
      button.classList.add("btext-white");
    }
  }
}
