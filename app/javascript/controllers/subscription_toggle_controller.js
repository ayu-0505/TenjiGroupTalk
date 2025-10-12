import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from "@rails/request.js";

export default class extends Controller {
  static values = { talkId: Number };
  static targets = ["check", "id", "switch"];

  connect() {
    console.log(this.talkIdValue);
    console.log(this.checkTarget.checked);
    console.log(this.talkIdValue.class);
  }

  async toggle() {
    // const isCreate = this.checkTarget.checked === true;
    // const httpRequest = isCreate ? "post" : "delete";
    // const url = isCreate
    //   ? "/api/subscriptions"
    //   : `/api/subscriptions/${this.idTarget}`;

    if (this.checkTarget.checked) {
      const request = new FetchRequest("post", "/api/subscriptions", {
        body: JSON.stringify({ talk_id: this.talkIdValue }),
      });
      const response = await request.perform();
      const data = await response.json;
      if (response.ok) {
        this.idTarget.setAttribute("id", data.id);
        const flashContainer = document.getElementById("flash");
        flashContainer.innerHTML = data.html;
        this.switchTarget.classList.remove("left-[3px]", "bg-sky-300");
        this.switchTarget.classList.add("left-8", "bg-sky-600");
      }
      // save失敗時の処理
    } else {
      const request = new FetchRequest(
        "delete",
        `/api/subscriptions/${this.idTarget.getAttribute("id")}`
      );
      const response = await request.perform();
      const data = await response.json;
      if (response.ok) {
        const flashContainer = document.getElementById("flash");
        flashContainer.innerHTML = data.html;
        this.idTarget.removeAttribute("id");
        this.switchTarget.removeAttribute("checked");
        this.switchTarget.classList.remove("left-8", "bg-sky-600");
        this.switchTarget.classList.add("left-[3px]", "bg-sky-300");
      }
    }
  }
}
