import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["original", "buttonText"];

  toggle() {
    const content = this.originalTarget;
    content.classList.toggle("hidden");
    if (content.classList.contains("hidden")) {
      this.buttonTextTarget.textContent = "正解を見る";
    } else {
      this.buttonTextTarget.textContent = "正解をかくす";
    }
  }
}
