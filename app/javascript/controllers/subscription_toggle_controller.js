import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from "@rails/request.js";

export default class extends Controller {
  static values = { talkId: Number };
  static targets = ["subscriptionCheck", "id", "switch"];

  async toggle() {
    if (this.subscriptionCheckTarget.checked) {
      await this.createSubscription();
    } else {
      await this.deleteSubscription();
    }
  }

  async createSubscription() {
    const request = new FetchRequest("post", "/api/subscriptions", {
      body: JSON.stringify({ talk_id: this.talkIdValue }),
    });
    const response = await request.perform();
    if (!response.ok) return;

    const data = await response.json;
    this.idTarget.setAttribute("id", data.id);
    const flashContainer = document.getElementById("flash");
    flashContainer.innerHTML = data.html;
    this.switchTarget.classList.remove("left-0.5", "bg-sky-300");
    this.switchTarget.classList.add("left-5", "bg-sky-600");
  }

  async deleteSubscription() {
    const request = new FetchRequest(
      "delete",
      `/api/subscriptions/${this.idTarget.getAttribute("id")}`
    );
    const response = await request.perform();
    if (!response.ok) return;

    const data = await response.json;
    const flashContainer = document.getElementById("flash");
    flashContainer.innerHTML = data.html;
    this.idTarget.removeAttribute("id");
    this.switchTarget.removeAttribute("checked");
    this.switchTarget.classList.remove("left-5", "bg-sky-600");
    this.switchTarget.classList.add("left-0.5", "bg-sky-300");
  }
}
