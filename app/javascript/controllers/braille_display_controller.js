import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "originalCheck",
    "originalToggle",
    "originalPlaceholder",
    "original",

    "raisedCheck",
    "raisedToggle",
    "raisedPlaceholder",
    "raised",

    "indentedCheck",
    "indentedToggle",
    "indentedPlaceholder",
    "indented",
  ];

  toggle(event) {
    const targetName = event.currentTarget.dataset.brailleDisplayTarget.replace(
      "Check",
      ""
    );
    const content = this[`${targetName}Target`];
    content.classList.toggle("hidden");
    const placeholder = this[`${targetName}PlaceholderTarget`];
    placeholder.classList.toggle("hidden");
    const toggle = this[`${targetName}ToggleTarget`];

    if (content.classList.contains("hidden")) {
      toggle.classList.remove("bg-sky-600", "left-5");
      toggle.classList.add("bg-sky-300", "left-0.5");
    } else {
      toggle.classList.remove("bg-sky-300", "left-0.5");
      toggle.classList.add("bg-sky-600", "left-5");
    }
  }
}
