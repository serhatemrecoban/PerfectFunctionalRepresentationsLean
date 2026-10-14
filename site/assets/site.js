"use strict";
document.documentElement.classList.add("js");
for (const button of document.querySelectorAll("[data-copy]")) {
  button.addEventListener("click", async () => {
    const target = document.getElementById(button.dataset.copy);
    const status = button.closest(".code-block").querySelector(".copy-status");
    if (!target || !status) return;
    try {
      if (!navigator.clipboard) throw new Error("Clipboard unavailable");
      await navigator.clipboard.writeText(target.textContent);
      status.textContent = "Copied to clipboard.";
    } catch {
      status.textContent = "Clipboard unavailable. Select the text and copy it manually.";
      const selection = window.getSelection();
      if (selection) {
        try {
          const range = document.createRange();
          range.selectNodeContents(target);
          selection.removeAllRanges();
          selection.addRange(range);
          status.textContent = "Clipboard unavailable. Text selected; use your device’s copy command.";
        } catch {
          // Keep the manual-copy guidance if selection is unavailable too.
        }
      }
    }
  });
}
