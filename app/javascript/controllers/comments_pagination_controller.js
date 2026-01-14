import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { ids: Array, incrementSize: Number };
  static targets = ["comment", "moreButtonContainer", "remainingCount"];

  connect() {
    this.remainingCount = this.idsValue.length;
    this.remainingIds = this.idsValue;
  }

  moreComments() {
    if (this.remainingCount === 0) {
      const parent = this.moreButtonContainerTarget;
      if (parent) {
        parent.remove();
      }
      return;
    }

    if (this.remainingCount <= this.incrementSizeValue) {
      this.commentTargets.forEach((comment) => {
        comment.classList.remove("hidden");
      });
      this.remainingCount = 0;
      const parent = this.moreButtonContainerTarget;
      if (parent) {
        parent.remove();
      }
    } else {
      const nextCommentIds = this.remainingIds.splice(
        0,
        this.incrementSizeValue
      );
      this.remainingCount = this.remainingCount - this.incrementSizeValue;
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
