import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from "@rails/request.js";

// Connects to data-controller="braille-convert"
export default class extends Controller {
  static targets = ["input", "result", "raised", "indented"];

  async convert() {
    const text = this.inputTarget.value;
    const request = new FetchRequest("post", "/api/braille_converter", {
      body: JSON.stringify({ text: text }),
    });
    const response = await request.perform();
    const data = await response.json;

    this.resultTarget.classList.remove("hidden");
    this.raisedTarget.textContent = data.raised;
    this.indentedTarget.textContent = data.indented;
  }
}
