import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="braille-display"
export default class extends Controller {
  static targets = [
    "originalBtn",
    "original",
    "raisedBtn",
    "raised",
    "indentedBtn",
    "indented",
  ];

  toggle(event) {
    const targetName = event.currentTarget.dataset.brailleDisplayTarget.replace(
      "Btn",
      ""
    );
    const content = this[`${targetName}Target`];
    content.classList.toggle("hidden");
    const btn = event.currentTarget;

    if (content.classList.contains("hidden")) {
      btn.textContent = btn.textContent.replace("非表示", "表示");
    } else {
      btn.textContent = btn.textContent.replace("表示", "非表示");
    }
  }
}
