import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { ids: Array };
  static targets = ["comment", "moreBtn", "remainingCount"];

  connect() {
    this.remainingCount = this.idsValue.length;
    this.remainingIds = this.idsValue;
  }

  moreComments() {
    const incrementSize = 5;

    if (this.remainingCount === 0) {
      const parent = this.moreBtnTarget.closest(".flex");
      if (parent) {
        parent.remove();
      }
      return;
    }

    if (this.remainingCount <= incrementSize) {
      this.commentTargets.forEach((comment) => {
        comment.classList.remove("hidden");
      });
      this.remainingCount = 0;
      const parent = this.moreBtnTarget.closest(".flex");
      if (parent) {
        parent.remove();
      }
    } else {
      const nextCommentIds = this.remainingIds.splice(-incrementSize);
      this.remainingCount = this.remainingCount - incrementSize;
      this.remainingCountTarget.textContent = this.remainingCount;
      nextCommentIds.forEach((id) => {
        const comment = this.commentTargets.find(
          (comment) => comment.id === id.toString()
        );
        comment.classList.remove("hidden");
      });
    }
  }
}
