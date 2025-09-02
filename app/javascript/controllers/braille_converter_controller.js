import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="braille-convert"
export default class extends Controller {
  static targets = ["input", "raised", "indented"];

  async convert() {
    const text = this.inputTarget.value;
    const response = await fetch("/api/braille_converter", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.head.querySelector("meta[name=csrf-token]")
          ?.content,
      },
      body: JSON.stringify({ text: text }),
    });

    const data = await response.json();

    this.raisedTarget.textContent = data.raised;
    this.indentedTarget.textContent = data.indented;
  }
}
