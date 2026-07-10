/**
 * Vim-style quit extension — type ":q" to exit pi.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("input", async (event, ctx) => {
    // Only handle ":q" typed interactively by the user
    if (event.source !== "interactive") return { action: "continue" };

    const trimmed = event.text.trim();
    if (trimmed === ":q" || trimmed === ":q!") {
      // For :q! force quit; for :q show a brief notification and exit
      ctx.shutdown();
      return { action: "handled" };
    }

    return { action: "continue" };
  });
}
